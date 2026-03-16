#!/usr/bin/env bash
set -euo pipefail

# Basic DAST runbook runner for Nuclei (HTTP templates).
# CI/CD standalone mode:
# - Docker runner only (projectdiscovery/nuclei)
# - No local Nuclei dependency
#
# Preferred env var names:
# - DAST_TARGET_URL, DAST_REPORT_PREFIX, DAST_DOCKER_IMAGE
# - DAST_FAIL_ON_FAILS, DAST_FAIL_ON_WARNINGS
# - SEC_OUTPUT_DIR (shared)
# Backward-compatible fallbacks are still supported.

TARGET_URL="${DAST_TARGET_URL:-${TARGET_URL:-}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
REPORT_PREFIX="${DAST_REPORT_PREFIX:-${REPORT_PREFIX:-nuclei-report}}"
IMAGE="${DAST_DOCKER_IMAGE:-${NUCLEI_IMAGE:-projectdiscovery/nuclei:latest}}"
FAIL_ON_FAILS="${DAST_FAIL_ON_FAILS:-${FAIL_ON_FAILS:-true}}"
FAIL_ON_WARNINGS="${DAST_FAIL_ON_WARNINGS:-${SEC_FAIL_ON_WARNINGS:-${FAIL_ON_WARNINGS:-false}}}"

# Nuclei tuning
NUCLEI_PROFILE="${DAST_NUCLEI_PROFILE:-balanced}" # baseline | balanced | aggressive
NUCLEI_SEVERITY="${DAST_NUCLEI_SEVERITY:-}"
NUCLEI_RATE_LIMIT="${DAST_NUCLEI_RATE_LIMIT:-}"
NUCLEI_TIMEOUT="${DAST_NUCLEI_TIMEOUT:-}"
NUCLEI_TAGS="${DAST_NUCLEI_TAGS:-}"
NUCLEI_TEMPLATES="${DAST_NUCLEI_TEMPLATES:-}"
NUCLEI_EXCLUDE_TAGS="${DAST_NUCLEI_EXCLUDE_TAGS:-}"
NUCLEI_AUTO_SCAN="${DAST_NUCLEI_AUTO_SCAN:-}"
NUCLEI_UPDATE_TEMPLATES="${DAST_NUCLEI_UPDATE_TEMPLATES:-}"
NUCLEI_EXTRA_ARGS="${DAST_NUCLEI_EXTRA_ARGS:-}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/dast-nuclei-basic.sh [options] <target-url>

Examples:
  ./runbooks/appsec/dast-nuclei-basic.sh https://your-app-url.example
  DAST_TARGET_URL=http://host.docker.internal:3001 ./runbooks/appsec/dast-nuclei-basic.sh
  DAST_NUCLEI_TAGS=xss,sqli ./runbooks/appsec/dast-nuclei-basic.sh https://your-app-url.example

Options:
  -t, --target-url <url>      Target URL to scan
      --output-dir <dir>      Output directory (default: ./artifacts/security)
      --report-prefix <name>  Report prefix (default: nuclei-report)
      --profile <name>        baseline|balanced|aggressive
      --help                  Show this help

Optional env vars:
  DAST_TARGET_URL         Target URL to scan
  SEC_OUTPUT_DIR          Shared output directory (default: ./artifacts/security)
  DAST_REPORT_PREFIX      Report prefix (default: nuclei-report)
  DAST_DOCKER_IMAGE       Docker image (default: projectdiscovery/nuclei:latest)
  DAST_FAIL_ON_FAILS      true|false (default: true)
  DAST_FAIL_ON_WARNINGS   true|false (default: false)
  DAST_NUCLEI_PROFILE     baseline|balanced|aggressive (default: balanced)
  DAST_NUCLEI_SEVERITY    Severity list override
  DAST_NUCLEI_RATE_LIMIT  Requests per second override
  DAST_NUCLEI_TIMEOUT     Timeout seconds override
  DAST_NUCLEI_TAGS        Optional tags to include (comma-separated)
  DAST_NUCLEI_TEMPLATES   Optional templates/dirs to include
  DAST_NUCLEI_EXCLUDE_TAGS Optional tags to exclude (comma-separated)
  DAST_NUCLEI_AUTO_SCAN   true|false, enables -as
  DAST_NUCLEI_UPDATE_TEMPLATES true|false, enables -ut
  DAST_NUCLEI_EXTRA_ARGS  Additional nuclei args

Legacy env vars still accepted:
  TARGET_URL, OUTPUT_DIR, REPORT_PREFIX, NUCLEI_IMAGE, FAIL_ON_FAILS, FAIL_ON_WARNINGS
EOF
}

apply_profile_defaults() {
  case "$NUCLEI_PROFILE" in
    baseline)
      : "${NUCLEI_SEVERITY:=critical,high}"
      : "${NUCLEI_RATE_LIMIT:=100}"
      : "${NUCLEI_TIMEOUT:=10}"
      : "${NUCLEI_AUTO_SCAN:=false}"
      : "${NUCLEI_UPDATE_TEMPLATES:=false}"
      ;;
    balanced)
      : "${NUCLEI_SEVERITY:=critical,high,medium,low,info}"
      : "${NUCLEI_RATE_LIMIT:=150}"
      : "${NUCLEI_TIMEOUT:=10}"
      : "${NUCLEI_AUTO_SCAN:=true}"
      : "${NUCLEI_UPDATE_TEMPLATES:=true}"
      ;;
    aggressive)
      : "${NUCLEI_SEVERITY:=critical,high,medium,low,info}"
      : "${NUCLEI_RATE_LIMIT:=250}"
      : "${NUCLEI_TIMEOUT:=15}"
      : "${NUCLEI_AUTO_SCAN:=true}"
      : "${NUCLEI_UPDATE_TEMPLATES:=true}"
      if [[ -z "$NUCLEI_TAGS" ]]; then
        NUCLEI_TAGS="xss,sqli,lfi,rce,ssrf,cors,redirect,exposure,misconfig,panel,default-login,takeover"
      fi
      ;;
    *)
      echo "Error: DAST_NUCLEI_PROFILE must be baseline|balanced|aggressive (got '$NUCLEI_PROFILE')." >&2
      exit 64
      ;;
  esac
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
    --profile)
      NUCLEI_PROFILE="${2:-}"
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

apply_profile_defaults

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
  if [[ ! -f "$JSONL_REPORT" ]]; then
    echo "Nuclei Summary: JSONL report not found at $JSONL_REPORT"
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "Nuclei Summary: python3 not available; skipping summary."
    return 0
  fi

  python3 - "$JSONL_REPORT" <<'PY'
import collections
import json
import sys

path = sys.argv[1]
counts = collections.Counter()
rows = []

try:
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                item = json.loads(line)
            except Exception:
                continue
            info = item.get("info") or {}
            severity = str(info.get("severity") or "unknown").lower()
            name = str(info.get("name") or item.get("template-id") or "unknown")
            matched = str(item.get("matched-at") or item.get("host") or "")
            counts[severity] += 1
            rows.append((severity, name, matched))
except Exception as e:
    print(f"Nuclei Summary: unable to parse JSONL report: {e}")
    raise SystemExit(0)

total = sum(counts.values())
print("Nuclei Summary:")
print(f"  findings: {total}")
if total == 0:
    print("  severities: none")
    raise SystemExit(0)

for sev in ["critical", "high", "medium", "low", "info", "unknown"]:
    if counts.get(sev):
        print(f"  {sev}: {counts[sev]}")

weights = {"critical": 5, "high": 4, "medium": 3, "low": 2, "info": 1, "unknown": 0}
rows.sort(key=lambda x: (weights.get(x[0], 0), x[1]), reverse=True)
print("  top_findings:")
for sev, name, matched in rows[:10]:
    suffix = f" @ {matched}" if matched else ""
    print(f"    - [{sev}] {name}{suffix}")
PY
}

derive_exit_code_from_report() {
  if [[ ! -f "$JSONL_REPORT" || ! -s "$JSONL_REPORT" ]]; then
    echo 0
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo 0
    return 0
  fi

  python3 - "$JSONL_REPORT" <<'PY'
import json
import sys

path = sys.argv[1]
has_fail = False
has_warn = False

with open(path, "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            item = json.loads(line)
        except Exception:
            continue
        sev = str((item.get("info") or {}).get("severity") or "unknown").lower()
        if sev in {"critical", "high", "medium"}:
            has_fail = True
        elif sev in {"low", "info"}:
            has_warn = True

if has_fail:
    print(1)
elif has_warn:
    print(2)
else:
    print(0)
PY
}

mkdir -p "$OUTPUT_DIR"
ABS_OUTPUT_DIR="$(resolve_abs_path "$OUTPUT_DIR")"
JSONL_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.jsonl"

echo "Starting Nuclei runbook..."
echo "  target_url: $TARGET_URL"
echo "  output_dir: $OUTPUT_DIR"
echo "  report_jsonl: $JSONL_REPORT"
echo "  profile: $NUCLEI_PROFILE"
echo "  severity: $NUCLEI_SEVERITY"
echo "  rate_limit: $NUCLEI_RATE_LIMIT"
echo "  timeout: $NUCLEI_TIMEOUT"
echo "  auto_scan: $NUCLEI_AUTO_SCAN"
echo "  update_templates: $NUCLEI_UPDATE_TEMPLATES"
if [[ -n "$NUCLEI_TAGS" ]]; then
  echo "  tags: $NUCLEI_TAGS"
fi
echo "  runner: docker"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi

NUCLEI_ARGS=(
  "-u" "$TARGET_URL"
  "-jsonl"
  "-o" "/work/$(basename "$JSONL_REPORT")"
  "-severity" "$NUCLEI_SEVERITY"
  "-rate-limit" "$NUCLEI_RATE_LIMIT"
  "-timeout" "$NUCLEI_TIMEOUT"
)

if [[ -n "$NUCLEI_TAGS" ]]; then
  NUCLEI_ARGS+=("-tags" "$NUCLEI_TAGS")
fi
if [[ -n "$NUCLEI_TEMPLATES" ]]; then
  NUCLEI_ARGS+=("-t" "$NUCLEI_TEMPLATES")
fi
if [[ -n "$NUCLEI_EXCLUDE_TAGS" ]]; then
  NUCLEI_ARGS+=("-etags" "$NUCLEI_EXCLUDE_TAGS")
fi
if [[ "$NUCLEI_AUTO_SCAN" == "true" ]]; then
  NUCLEI_ARGS+=("-as")
fi
if [[ "$NUCLEI_UPDATE_TEMPLATES" == "true" ]]; then
  NUCLEI_ARGS+=("-ut")
fi
if [[ -n "$NUCLEI_EXTRA_ARGS" ]]; then
  # shellcheck disable=SC2206
  EXTRA_ARGS=( $NUCLEI_EXTRA_ARGS )
  NUCLEI_ARGS+=("${EXTRA_ARGS[@]}")
fi

set +e
docker run --rm \
  -v "$ABS_OUTPUT_DIR:/work" \
  "$IMAGE" \
  "${NUCLEI_ARGS[@]}"
SCAN_EXIT_CODE=$?
set -e

print_report_summary

if [[ "$SCAN_EXIT_CODE" -gt 1 ]]; then
  echo "Nuclei tooling/runtime error (exit $SCAN_EXIT_CODE)." >&2
  exit "$SCAN_EXIT_CODE"
fi

DERIVED_EXIT_CODE="$(derive_exit_code_from_report)"
if [[ "$DERIVED_EXIT_CODE" -eq 1 ]]; then
  if [[ "$FAIL_ON_FAILS" == "false" ]]; then
    echo "Nuclei fail-level findings detected, but DAST_FAIL_ON_FAILS=false. Continuing with exit 0."
    exit 0
  fi
  exit 1
fi

if [[ "$DERIVED_EXIT_CODE" -eq 2 ]]; then
  if [[ "$FAIL_ON_WARNINGS" == "false" ]]; then
    echo "Nuclei warning-level findings detected, but DAST_FAIL_ON_WARNINGS=false. Continuing with exit 0."
    exit 0
  fi
  exit 2
fi

exit 0
