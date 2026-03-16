#!/usr/bin/env bash
set -euo pipefail

# Basic secrets scanning runbook runner for TruffleHog.
# CI/CD standalone mode:
# - Docker runner only (trufflesecurity/trufflehog)
# - No local TruffleHog dependency
#
# Preferred env var names:
# - SECRETS_SCAN_PATH, SECRETS_REPORT_PREFIX, SECRETS_DOCKER_IMAGE
# - SECRETS_FAIL_ON_FINDINGS
# - SEC_OUTPUT_DIR (shared)
# Backward-compatible fallbacks are still supported.

SCAN_PATH="${SECRETS_SCAN_PATH:-${SCAN_PATH:-.}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
REPORT_PREFIX="${SECRETS_REPORT_PREFIX:-${REPORT_PREFIX:-trufflehog-results}}"
IMAGE="${SECRETS_DOCKER_IMAGE:-${TRUFFLEHOG_IMAGE:-trufflesecurity/trufflehog:latest}}"
FAIL_ON_FINDINGS="${SECRETS_FAIL_ON_FINDINGS:-${FAIL_ON_FINDINGS:-true}}"

# Detection tuning
TRUFFLEHOG_ONLY_VERIFIED="${SECRETS_ONLY_VERIFIED:-${TRUFFLEHOG_ONLY_VERIFIED:-false}}"
TRUFFLEHOG_NO_VERIFICATION="${SECRETS_NO_VERIFICATION:-${TRUFFLEHOG_NO_VERIFICATION:-false}}"
TRUFFLEHOG_EXTRA_ARGS="${SECRETS_TRUFFLEHOG_EXTRA_ARGS:-}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/secrets-trufflehog-basic.sh [options]

Examples:
  ./runbooks/appsec/secrets-trufflehog-basic.sh
  SECRETS_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/secrets-trufflehog-basic.sh
  SECRETS_ONLY_VERIFIED=true ./runbooks/appsec/secrets-trufflehog-basic.sh

Options:
  --scan-path <path>         Path to scan (default: .)
  --output-dir <dir>         Output directory (default: ./artifacts/security)
  --report-prefix <name>     Report prefix (default: trufflehog-results)
  --help                     Show this help

Optional env vars:
  SECRETS_SCAN_PATH           Path to scan (default: .)
  SEC_OUTPUT_DIR              Shared output directory (default: ./artifacts/security)
  SECRETS_REPORT_PREFIX       Report prefix (default: trufflehog-results)
  SECRETS_DOCKER_IMAGE        Docker image (default: trufflesecurity/trufflehog:latest)
  SECRETS_FAIL_ON_FINDINGS    true|false (default: true)
  SECRETS_ONLY_VERIFIED       true|false (default: false)
  SECRETS_NO_VERIFICATION     true|false (default: false)
  SECRETS_TRUFFLEHOG_EXTRA_ARGS Additional TruffleHog args

Legacy env vars still accepted:
  SCAN_PATH, OUTPUT_DIR, REPORT_PREFIX, TRUFFLEHOG_IMAGE, FAIL_ON_FINDINGS
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --scan-path)
      SCAN_PATH="${2:-}"
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
      echo "Error: unexpected argument '$1'." >&2
      usage >&2
      exit 64
      ;;
  esac
done

resolve_abs_path() {
  local path="$1"
  if [[ "$path" = /* ]]; then
    printf '%s\n' "$path"
  else
    printf '%s/%s\n' "$PWD" "${path#./}"
  fi
}

to_container_path() {
  local value="$1"
  if [[ "$value" = /* ]]; then
    case "$value" in
      "$PWD"/*)
        printf '/src/%s\n' "${value#"$PWD"/}"
        ;;
      *)
        echo "Path '$value' must be relative, or inside the current workspace ($PWD)." >&2
        return 1
        ;;
    esac
  else
    printf '/src/%s\n' "${value#./}"
  fi
}

print_report_summary() {
  if [[ ! -f "$JSON_REPORT" ]]; then
    echo "TruffleHog Summary: JSON report not found at $JSON_REPORT"
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "TruffleHog Summary: python3 not available; skipping summary."
    return 0
  fi

  python3 - "$JSON_REPORT" <<'PY'
import collections
import json
import sys

path = sys.argv[1]
findings = []

try:
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                findings.append(json.loads(line))
            except Exception:
                continue
except Exception as e:
    print(f"TruffleHog Summary: unable to parse JSON report: {e}")
    raise SystemExit(0)

print("TruffleHog Summary:")
print(f"  findings: {len(findings)}")
if not findings:
    print("  detector_counts: none")
    raise SystemExit(0)

detector_counts = collections.Counter()
verified_count = 0
rows = []
for item in findings:
    detector = str(item.get("DetectorName") or "UnknownDetector")
    verified = bool(item.get("Verified", False))
    source = str(item.get("SourceName") or item.get("SourceMetadata", {}).get("Data", {}).get("Git", {}).get("commit") or "")
    detector_counts[detector] += 1
    if verified:
        verified_count += 1
    rows.append((verified, detector, source))

print(f"  verified: {verified_count}")
print(f"  unverified: {len(findings) - verified_count}")

for detector, count in detector_counts.most_common(10):
    print(f"  detector[{detector}]: {count}")

print("  top_findings:")
for verified, detector, source in rows[:10]:
    v = "verified" if verified else "unverified"
    suffix = f" @ {source}" if source else ""
    print(f"    - [{v}] {detector}{suffix}")
PY
}

count_findings() {
  if [[ ! -f "$JSON_REPORT" || ! -s "$JSON_REPORT" ]]; then
    echo 0
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo 0
    return 0
  fi

  python3 - "$JSON_REPORT" <<'PY'
import json
import sys

path = sys.argv[1]
count = 0
with open(path, "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            json.loads(line)
            count += 1
        except Exception:
            pass
print(count)
PY
}

mkdir -p "$OUTPUT_DIR"
ABS_OUTPUT_DIR="$(resolve_abs_path "$OUTPUT_DIR")"
JSON_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.jsonl"
CONTAINER_SCAN_PATH="$(to_container_path "$SCAN_PATH")"

echo "Starting TruffleHog runbook..."
echo "  scan_path: $SCAN_PATH"
echo "  output_dir: $OUTPUT_DIR"
echo "  report_jsonl: $JSON_REPORT"
echo "  only_verified: $TRUFFLEHOG_ONLY_VERIFIED"
echo "  no_verification: $TRUFFLEHOG_NO_VERIFICATION"
echo "  runner: docker"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi

TRUFFLEHOG_ARGS=(
  "filesystem"
  "$CONTAINER_SCAN_PATH"
  "--json"
)

if [[ "$TRUFFLEHOG_ONLY_VERIFIED" == "true" ]]; then
  TRUFFLEHOG_ARGS+=("--only-verified")
fi
if [[ "$TRUFFLEHOG_NO_VERIFICATION" == "true" ]]; then
  TRUFFLEHOG_ARGS+=("--no-verification")
fi
if [[ -n "$TRUFFLEHOG_EXTRA_ARGS" ]]; then
  # shellcheck disable=SC2206
  EXTRA_ARGS=( $TRUFFLEHOG_EXTRA_ARGS )
  TRUFFLEHOG_ARGS+=("${EXTRA_ARGS[@]}")
fi

set +e
docker run --rm \
  -v "$PWD:/src" \
  "$IMAGE" \
  "${TRUFFLEHOG_ARGS[@]}" > "$JSON_REPORT"
SCAN_EXIT_CODE=$?
set -e

print_report_summary

if [[ "$SCAN_EXIT_CODE" -gt 1 ]]; then
  echo "TruffleHog tooling/runtime error (exit $SCAN_EXIT_CODE)." >&2
  exit "$SCAN_EXIT_CODE"
fi

FINDING_COUNT="$(count_findings)"
if [[ "$FINDING_COUNT" -gt 0 ]]; then
  if [[ "$FAIL_ON_FINDINGS" == "false" ]]; then
    echo "Secrets findings detected ($FINDING_COUNT), but SECRETS_FAIL_ON_FINDINGS=false. Continuing with exit 0."
    exit 0
  fi
  exit 1
fi

exit 0
