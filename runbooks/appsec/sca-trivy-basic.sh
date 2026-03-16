#!/usr/bin/env bash
set -euo pipefail

# Basic SCA runbook runner for Trivy filesystem scanning.
# CI/CD standalone mode:
# - Docker runner only (aquasec/trivy)
# - No local Trivy dependency
#
# Preferred env var names:
# - SCA_SCAN_PATH, SCA_REPORT_PREFIX, SCA_DOCKER_IMAGE
# - SCA_FAIL_ON_FAILS, SCA_FAIL_ON_WARNINGS
# - SEC_OUTPUT_DIR (shared)
# Backward-compatible fallbacks are still supported.

SCAN_PATH="${SCA_SCAN_PATH:-${SCAN_PATH:-.}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
REPORT_PREFIX="${SCA_REPORT_PREFIX:-${REPORT_PREFIX:-trivy-sca}}"
IMAGE="${SCA_DOCKER_IMAGE:-${TRIVY_IMAGE:-aquasec/trivy:latest}}"
FAIL_ON_FAILS="${SCA_FAIL_ON_FAILS:-${FAIL_ON_FAILS:-true}}"
FAIL_ON_WARNINGS="${SCA_FAIL_ON_WARNINGS:-${SEC_FAIL_ON_WARNINGS:-${FAIL_ON_WARNINGS:-false}}}"

# Trivy tuning
TRIVY_SEVERITY="${SCA_TRIVY_SEVERITY:-CRITICAL,HIGH,MEDIUM,LOW}"
TRIVY_IGNORE_UNFIXED="${SCA_TRIVY_IGNORE_UNFIXED:-false}"
TRIVY_SKIP_DB_UPDATE="${SCA_TRIVY_SKIP_DB_UPDATE:-false}"
TRIVY_EXTRA_ARGS="${SCA_TRIVY_EXTRA_ARGS:-}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/sca-trivy-basic.sh [options]

Examples:
  ./runbooks/appsec/sca-trivy-basic.sh
  SCA_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/sca-trivy-basic.sh
  SCA_TRIVY_SEVERITY=CRITICAL,HIGH ./runbooks/appsec/sca-trivy-basic.sh

Options:
  --scan-path <path>         Path to scan (default: .)
  --output-dir <dir>         Output directory (default: ./artifacts/security)
  --report-prefix <name>     Report prefix (default: trivy-sca)
  --help                     Show this help

Optional env vars:
  SCA_SCAN_PATH              Path to scan (default: .)
  SEC_OUTPUT_DIR             Shared output directory (default: ./artifacts/security)
  SCA_REPORT_PREFIX          Report prefix (default: trivy-sca)
  SCA_DOCKER_IMAGE           Docker image (default: aquasec/trivy:latest)
  SCA_FAIL_ON_FAILS          true|false (default: true)
  SCA_FAIL_ON_WARNINGS       true|false (default: false)
  SCA_TRIVY_SEVERITY         Severity list (default: CRITICAL,HIGH,MEDIUM,LOW)
  SCA_TRIVY_IGNORE_UNFIXED   true|false (default: false)
  SCA_TRIVY_SKIP_DB_UPDATE   true|false (default: false)
  SCA_TRIVY_EXTRA_ARGS       Additional Trivy args

Legacy env vars still accepted:
  SCAN_PATH, OUTPUT_DIR, REPORT_PREFIX, TRIVY_IMAGE, FAIL_ON_FAILS, FAIL_ON_WARNINGS
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
    echo "Trivy Summary: JSON report not found at $JSON_REPORT"
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "Trivy Summary: python3 not available; skipping summary."
    return 0
  fi

  python3 - "$JSON_REPORT" <<'PY'
import collections
import json
import sys

path = sys.argv[1]
try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
except Exception as e:
    print(f"Trivy Summary: unable to parse JSON report: {e}")
    raise SystemExit(0)

counts = collections.Counter()
rows = []

for result in data.get("Results", []) if isinstance(data, dict) else []:
    target = str(result.get("Target") or "")
    for vuln in result.get("Vulnerabilities") or []:
        sev = str(vuln.get("Severity") or "UNKNOWN").upper()
        vid = str(vuln.get("VulnerabilityID") or "")
        pkg = str(vuln.get("PkgName") or "")
        counts[sev] += 1
        rows.append((sev, vid, pkg, target))

total = sum(counts.values())
print("Trivy Summary:")
print(f"  vulnerabilities: {total}")
if total == 0:
    print("  severities: none")
    raise SystemExit(0)

for sev in ["CRITICAL", "HIGH", "MEDIUM", "LOW", "UNKNOWN"]:
    if counts.get(sev):
        print(f"  {sev}: {counts[sev]}")

weights = {"CRITICAL": 5, "HIGH": 4, "MEDIUM": 3, "LOW": 2, "UNKNOWN": 1}
rows.sort(key=lambda x: (weights.get(x[0], 0), x[1], x[2]), reverse=True)
print("  top_vulnerabilities:")
for sev, vid, pkg, target in rows[:10]:
    print(f"    - [{sev}] {vid} pkg={pkg} target={target}")
PY
}

derive_exit_code_from_report() {
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
has_fail = False
has_warn = False

try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
except Exception:
    print(0)
    raise SystemExit(0)

for result in data.get("Results", []) if isinstance(data, dict) else []:
    for vuln in result.get("Vulnerabilities") or []:
        sev = str(vuln.get("Severity") or "UNKNOWN").upper()
        if sev in {"CRITICAL", "HIGH", "MEDIUM"}:
            has_fail = True
        elif sev in {"LOW", "UNKNOWN"}:
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
JSON_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.json"
CONTAINER_SCAN_PATH="$(to_container_path "$SCAN_PATH")"

echo "Starting Trivy SCA runbook..."
echo "  scan_path: $SCAN_PATH"
echo "  output_dir: $OUTPUT_DIR"
echo "  report_json: $JSON_REPORT"
echo "  severity: $TRIVY_SEVERITY"
echo "  ignore_unfixed: $TRIVY_IGNORE_UNFIXED"
echo "  skip_db_update: $TRIVY_SKIP_DB_UPDATE"
echo "  runner: docker"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi

TRIVY_ARGS=(
  "fs"
  "--format" "json"
  "--output" "/work/$(basename "$JSON_REPORT")"
  "--severity" "$TRIVY_SEVERITY"
  "$CONTAINER_SCAN_PATH"
)

if [[ "$TRIVY_IGNORE_UNFIXED" == "true" ]]; then
  TRIVY_ARGS+=("--ignore-unfixed")
fi
if [[ "$TRIVY_SKIP_DB_UPDATE" == "true" ]]; then
  TRIVY_ARGS+=("--skip-db-update")
fi
if [[ -n "$TRIVY_EXTRA_ARGS" ]]; then
  # shellcheck disable=SC2206
  EXTRA_ARGS=( $TRIVY_EXTRA_ARGS )
  TRIVY_ARGS+=("${EXTRA_ARGS[@]}")
fi

set +e
docker run --rm \
  -v "$PWD:/src" \
  -v "$ABS_OUTPUT_DIR:/work" \
  "$IMAGE" \
  "${TRIVY_ARGS[@]}"
SCAN_EXIT_CODE=$?
set -e

print_report_summary

if [[ "$SCAN_EXIT_CODE" -gt 1 ]]; then
  echo "Trivy tooling/runtime error (exit $SCAN_EXIT_CODE)." >&2
  exit "$SCAN_EXIT_CODE"
fi

DERIVED_EXIT_CODE="$(derive_exit_code_from_report)"
if [[ "$DERIVED_EXIT_CODE" -eq 1 ]]; then
  if [[ "$FAIL_ON_FAILS" == "false" ]]; then
    echo "Trivy fail-level findings detected, but SCA_FAIL_ON_FAILS=false. Continuing with exit 0."
    exit 0
  fi
  exit 1
fi

if [[ "$DERIVED_EXIT_CODE" -eq 2 ]]; then
  if [[ "$FAIL_ON_WARNINGS" == "false" ]]; then
    echo "Trivy warning-level findings detected, but SCA_FAIL_ON_WARNINGS=false. Continuing with exit 0."
    exit 0
  fi
  exit 2
fi

exit 0
