#!/usr/bin/env bash
set -euo pipefail

# Basic DAST runbook runner for Burp Dastardly.
# CI/CD standalone mode:
# - Docker runner only (public.ecr.aws/portswigger/dastardly)
# - No local Burp dependency
#
# Preferred env var names:
# - DAST_TARGET_URL, DAST_REPORT_PREFIX, DAST_DOCKER_IMAGE
# - DAST_FAIL_ON_FAILS, DAST_FAIL_ON_WARNINGS
# - SEC_OUTPUT_DIR (shared)
# Backward-compatible fallbacks are still supported.

TARGET_URL="${DAST_TARGET_URL:-${TARGET_URL:-}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
REPORT_PREFIX="${DAST_REPORT_PREFIX:-${REPORT_PREFIX:-dastardly-report}}"
IMAGE="${DAST_DOCKER_IMAGE:-${DASTARDLY_IMAGE:-public.ecr.aws/portswigger/dastardly:latest}}"
DOCKER_PLATFORM="${DAST_DOCKER_PLATFORM:-}"
FAIL_ON_FAILS="${DAST_FAIL_ON_FAILS:-${FAIL_ON_FAILS:-true}}"
FAIL_ON_WARNINGS="${DAST_FAIL_ON_WARNINGS:-${SEC_FAIL_ON_WARNINGS:-${FAIL_ON_WARNINGS:-false}}}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/dast-dastardly-basic.sh [options] <target-url>

Examples:
  ./runbooks/appsec/dast-dastardly-basic.sh https://your-app-url.example
  DAST_TARGET_URL=https://your-app-url.example ./runbooks/appsec/dast-dastardly-basic.sh
  ./runbooks/appsec/dast-dastardly-basic.sh --target-url https://your-app-url.example --report-prefix dastardly
  DAST_DOCKER_PLATFORM=linux/amd64 ./runbooks/appsec/dast-dastardly-basic.sh http://host.docker.internal:3001

Options:
  -t, --target-url <url>      Target URL to scan
      --output-dir <dir>      Output directory (default: ./artifacts/security)
      --report-prefix <name>  Report prefix (default: dastardly-report)
      --docker-platform <p>   Docker platform override (e.g., linux/amd64)
      --help                  Show this help

Optional env vars:
  DAST_TARGET_URL       Target URL to scan
  SEC_OUTPUT_DIR        Shared output directory (default: ./artifacts/security)
  DAST_REPORT_PREFIX    Report prefix (default: dastardly-report)
  DAST_DOCKER_IMAGE     Docker image (default: public.ecr.aws/portswigger/dastardly:latest)
  DAST_DOCKER_PLATFORM  Docker platform override (example: linux/amd64)
  DAST_FAIL_ON_FAILS    true|false (default: true)
  DAST_FAIL_ON_WARNINGS true|false (default: false)
  SEC_FAIL_ON_WARNINGS  Shared warning gate fallback

Legacy env vars still accepted:
  TARGET_URL, OUTPUT_DIR, REPORT_PREFIX, DASTARDLY_IMAGE, FAIL_ON_FAILS, FAIL_ON_WARNINGS
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    -t|--target-url)
      TARGET_URL="${2:-}"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="${2:-}"
      shift 2
      ;;
    --report-prefix)
      REPORT_PREFIX="${2:-}"
      shift 2
      ;;
    --docker-platform)
      DOCKER_PLATFORM="${2:-}"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Error: unknown option '$1'." >&2
      usage >&2
      exit 64
      ;;
    *)
      if [[ -z "$TARGET_URL" ]]; then
        TARGET_URL="$1"
      else
        echo "Error: unexpected argument '$1'." >&2
        usage >&2
        exit 64
      fi
      shift
      ;;
  esac
done

if [[ -z "$TARGET_URL" ]]; then
  echo "Error: target URL is required." >&2
  usage >&2
  exit 64
fi

if [[ "$TARGET_URL" =~ ^https?://(localhost|127\.0\.0\.1)(:[0-9]+)?(/.*)?$ ]]; then
  echo "Error: DAST_TARGET_URL points to localhost/127.0.0.1, which is unreachable from the Docker scanner container." >&2
  echo "Use a network-reachable URL from the CI runner (for example https://your-app-url.example)." >&2
  echo "For local-only Docker testing, use http://host.docker.internal:<port> instead." >&2
  exit 64
fi

resolve_abs_path() {
  local path="$1"
  if [[ "$path" = /* ]]; then
    printf '%s\n' "$path"
  else
    printf '%s/%s\n' "$PWD" "${path#./}"
  fi
}

print_report_summary() {
  if [[ ! -f "$XML_REPORT" ]]; then
    echo "Dastardly Summary: XML report not found at $XML_REPORT"
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "Dastardly Summary: python3 not available; skipping summary."
    return 0
  fi

  python3 - "$XML_REPORT" <<'PY'
import sys
import xml.etree.ElementTree as ET

path = sys.argv[1]
try:
    root = ET.parse(path).getroot()
except Exception as e:
    print(f"Dastardly Summary: unable to parse XML report: {e}")
    raise SystemExit(0)

tests = int(root.attrib.get("tests", 0))
failures = int(root.attrib.get("failures", 0))
errors = int(root.attrib.get("errors", 0))
skipped = int(root.attrib.get("skipped", 0))

print("Dastardly Summary:")
print(f"  tests: {tests}")
print(f"  failures: {failures}")
print(f"  errors: {errors}")
print(f"  skipped: {skipped}")

if failures == 0 and errors == 0:
    print("  top_failures: none")
    raise SystemExit(0)

count = 0
print("  top_failures:")
for case in root.findall(".//testcase"):
    for node in list(case):
        if node.tag in {"failure", "error"}:
            name = case.attrib.get("name", "Unnamed test")
            msg = (node.attrib.get("message") or "").strip()
            msg = msg.replace("\n", " ")[:180]
            print(f"    - {name}: {msg}")
            count += 1
            if count >= 10:
                raise SystemExit(0)
PY
}

read_report_test_count() {
  if [[ ! -f "$XML_REPORT" ]] || ! command -v python3 >/dev/null 2>&1; then
    return 1
  fi

  python3 - "$XML_REPORT" <<'PY'
import sys
import xml.etree.ElementTree as ET

path = sys.argv[1]
try:
    root = ET.parse(path).getroot()
except Exception:
    raise SystemExit(1)

tests = int(root.attrib.get("tests", 0))
print(tests)
PY
}

mkdir -p "$OUTPUT_DIR"
ABS_OUTPUT_DIR="$(resolve_abs_path "$OUTPUT_DIR")"
XML_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.xml"

echo "Starting Dastardly runbook..."
echo "  target_url: $TARGET_URL"
echo "  output_dir: $OUTPUT_DIR"
echo "  report_xml: $XML_REPORT"
if [[ -n "$DOCKER_PLATFORM" ]]; then
  echo "  docker_platform: $DOCKER_PLATFORM"
fi
echo "  runner: docker"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi

DOCKER_RUN_CMD=(docker run --rm)
if [[ -n "$DOCKER_PLATFORM" ]]; then
  DOCKER_RUN_CMD+=(--platform "$DOCKER_PLATFORM")
fi
DOCKER_RUN_CMD+=(
  -v "$ABS_OUTPUT_DIR:/dastardly-reports"
  -e "BURP_START_URL=$TARGET_URL"
  -e "BURP_REPORT_FILE_PATH=/dastardly-reports/$(basename "$XML_REPORT")"
  "$IMAGE"
)

set +e
"${DOCKER_RUN_CMD[@]}"
SCAN_EXIT_CODE=$?
set -e

print_report_summary

# Dastardly commonly uses non-zero when checks fail.
if [[ "$SCAN_EXIT_CODE" -ne 0 ]]; then
  REPORT_TESTS=""
  if REPORT_TESTS="$(read_report_test_count)"; then
    if [[ "$REPORT_TESTS" == "0" ]]; then
      echo "Dastardly produced zero executed tests, indicating crawl/runtime startup failure." >&2
      echo "If running on Apple Silicon/ARM, try DAST_DOCKER_PLATFORM=linux/amd64." >&2
    fi
  fi

  if [[ "$FAIL_ON_FAILS" == "false" ]]; then
    echo "Dastardly findings detected, but DAST_FAIL_ON_FAILS=false. Continuing with exit 0."
    exit 0
  fi
  echo "Dastardly reported findings or runtime error (exit $SCAN_EXIT_CODE)." >&2
  exit "$SCAN_EXIT_CODE"
fi

# Optional warning gate reserved for future richer parsing tiers.
if [[ "$FAIL_ON_WARNINGS" == "false" ]]; then
  exit 0
fi

exit 0
