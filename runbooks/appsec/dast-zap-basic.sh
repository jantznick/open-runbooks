#!/usr/bin/env bash
set -euo pipefail

# Basic DAST runbook runner for OWASP ZAP baseline scan.
# Requires a target URL argument or TARGET_URL env var.
#
# CI/CD standalone mode:
# - Docker runner only (ghcr.io/zaproxy/zaproxy:stable)
# - No local ZAP dependency
#
# Exit behavior:
# - 0: no actionable findings (or warnings allowed)
# - 1: FAIL-level findings (when FAIL_ON_FAILS=true)
# - 2: WARN-level findings (when FAIL_ON_WARNINGS=true)
# - >2: tool/runtime/config error

# Preferred env var names:
# - DAST_TARGET_URL, DAST_REPORT_PREFIX, DAST_SCAN_MINUTES, DAST_SCAN_MODE
# - DAST_FAIL_ON_FAILS, DAST_FAIL_ON_WARNINGS, DAST_DOCKER_IMAGE
# - SEC_OUTPUT_DIR (shared)
# Backward-compatible fallbacks are still supported.
TARGET_URL="${DAST_TARGET_URL:-${TARGET_URL:-}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
REPORT_PREFIX="${DAST_REPORT_PREFIX:-${REPORT_PREFIX:-zap-baseline}}"
ZAP_IMAGE="${DAST_DOCKER_IMAGE:-${ZAP_IMAGE:-ghcr.io/zaproxy/zaproxy:stable}}"
ZAP_MINUTES="${DAST_SCAN_MINUTES:-${ZAP_MINUTES:-1}}"
SCAN_MODE="${DAST_SCAN_MODE:-baseline}" # baseline | full
FAIL_ON_FAILS="${DAST_FAIL_ON_FAILS:-${FAIL_ON_FAILS:-true}}"
FAIL_ON_WARNINGS="${DAST_FAIL_ON_WARNINGS:-${SEC_FAIL_ON_WARNINGS:-${FAIL_ON_WARNINGS:-false}}}"
ALLOW_PARTIAL_RESULTS="${DAST_ALLOW_PARTIAL_RESULTS:-false}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/dast-zap-basic.sh [options] <target-url>

Examples:
  ./runbooks/appsec/dast-zap-basic.sh https://your-app-url.example
  DAST_TARGET_URL=http://host.docker.internal:3001 ./runbooks/appsec/dast-zap-basic.sh
  DAST_SCAN_MODE=full DAST_SCAN_MINUTES=5 ./runbooks/appsec/dast-zap-basic.sh https://your-app-url.example
  ./runbooks/appsec/dast-zap-basic.sh --mode full --minutes 5 http://host.docker.internal:3001

Options:
  -t, --target-url <url>      Target URL to scan
  -m, --mode <baseline|full>  Scan mode (default: baseline)
  -n, --minutes <minutes>     Spider duration in minutes (default: 1)
      --output-dir <dir>      Output directory (default: ./artifacts/security)
      --report-prefix <name>  Output report prefix (default: zap-baseline)
      --help                  Show this help

Optional env vars:
  DAST_TARGET_URL      Target URL to scan (if not passed as arg)
  SEC_OUTPUT_DIR       Shared output directory (default: ./artifacts/security)
  DAST_REPORT_PREFIX   Report prefix (default: zap-baseline)
  DAST_DOCKER_IMAGE    Docker image (default: ghcr.io/zaproxy/zaproxy:stable)
  DAST_SCAN_MINUTES    Spider minutes (default: 1)
  DAST_SCAN_MODE       baseline|full (default: baseline)
  DAST_FAIL_ON_FAILS   true|false (default: true)
  DAST_FAIL_ON_WARNINGS true|false (default: false)
  DAST_ALLOW_PARTIAL_RESULTS true|false (default: false)
  SEC_FAIL_ON_WARNINGS true|false shared warning gate fallback

Legacy env vars still accepted:
  TARGET_URL, OUTPUT_DIR, REPORT_PREFIX, ZAP_IMAGE, ZAP_MINUTES,
  FAIL_ON_FAILS, FAIL_ON_WARNINGS
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
    -m|--mode)
      SCAN_MODE="${2:-}"
      shift 2
      ;;
    -n|--minutes)
      ZAP_MINUTES="${2:-}"
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
  echo "Error: TARGET_URL points to localhost/127.0.0.1, which is unreachable from the Docker scanner container." >&2
  echo "Use a network-reachable URL from the CI runner (for example https://your-app-url.example)." >&2
  echo "For local-only testing with Docker, use http://host.docker.internal:<port> instead." >&2
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

run_docker() {
  local json_file md_file html_file
  json_file="$(basename "$JSON_REPORT")"
  md_file="$(basename "$MD_REPORT")"
  html_file="$(basename "$HTML_REPORT")"

  local zap_cmd
  if [[ "$SCAN_MODE" == "baseline" ]]; then
    zap_cmd="zap-baseline.py"
  elif [[ "$SCAN_MODE" == "full" ]]; then
    zap_cmd="zap-full-scan.py"
  else
    echo "Error: DAST_SCAN_MODE must be 'baseline' or 'full' (got '$SCAN_MODE')." >&2
    return 64
  fi

  set +e
  docker run --rm \
    -v "$ABS_OUTPUT_DIR:/zap/wrk" \
    "$ZAP_IMAGE" \
    "$zap_cmd" \
      -t "$TARGET_URL" \
      -m "$ZAP_MINUTES" \
      -J "$json_file" \
      -w "$md_file" \
      -r "$html_file"
  SCAN_EXIT_CODE=$?
  set -e
}

print_report_summary() {
  if [[ ! -f "$JSON_REPORT" ]]; then
    echo "ZAP Summary: JSON report not found at $JSON_REPORT"
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "ZAP Summary: python3 not available; skipping summary."
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
    print(f"ZAP Summary: unable to parse JSON report: {e}")
    raise SystemExit(0)

alerts = []
if isinstance(data, dict):
    sites = data.get("site") or []
    if isinstance(sites, list):
        for site in sites:
            if isinstance(site, dict):
                site_alerts = site.get("alerts") or []
                if isinstance(site_alerts, list):
                    alerts.extend([a for a in site_alerts if isinstance(a, dict)])

    if not alerts and isinstance(data.get("alerts"), list):
        alerts.extend([a for a in data["alerts"] if isinstance(a, dict)])

print("ZAP Summary:")
print(f"  alert_types: {len(alerts)}")

if not alerts:
    print("  risk_counts: none")
    raise SystemExit(0)

risk_counts = collections.Counter()
rows = []
for alert in alerts:
    raw_risk = str(alert.get("riskdesc") or alert.get("risk") or "Unknown")
    risk = raw_risk.split(" ")[0]
    name = str(alert.get("name") or "Unnamed alert")
    instances = alert.get("instances")
    instance_count = len(instances) if isinstance(instances, list) else 0
    risk_counts[risk] += 1
    rows.append((risk, name, instance_count))

for key in ["High", "Medium", "Low", "Informational", "Info", "Unknown"]:
    if risk_counts.get(key):
        print(f"  {key}: {risk_counts[key]}")

other = sorted(k for k in risk_counts.keys() if k not in {"High", "Medium", "Low", "Informational", "Info", "Unknown"})
for key in other:
    print(f"  {key}: {risk_counts[key]}")

weights = {"High": 4, "Medium": 3, "Low": 2, "Informational": 1, "Info": 1}
rows.sort(key=lambda item: (weights.get(item[0], 0), item[2], item[1]), reverse=True)
print("  top_findings:")
for risk, name, instance_count in rows[:10]:
    print(f"    - [{risk}] {name} (instances: {instance_count})")
PY
}

derive_exit_code_from_report() {
  if [[ ! -f "$JSON_REPORT" || ! -s "$JSON_REPORT" ]]; then
    return 1
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    return 1
  fi

  python3 - "$JSON_REPORT" <<'PY'
import json
import sys

path = sys.argv[1]
try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
except Exception:
    raise SystemExit(1)

alerts = []
if isinstance(data, dict):
    sites = data.get("site") or []
    if isinstance(sites, list):
        for site in sites:
            if isinstance(site, dict):
                site_alerts = site.get("alerts") or []
                if isinstance(site_alerts, list):
                    alerts.extend([a for a in site_alerts if isinstance(a, dict)])
    if not alerts and isinstance(data.get("alerts"), list):
        alerts.extend([a for a in data["alerts"] if isinstance(a, dict)])

if not alerts:
    print(0)
    raise SystemExit(0)

risks = []
for alert in alerts:
    risk = str(alert.get("riskdesc") or alert.get("risk") or "Unknown").split(" ")[0]
    risks.append(risk)

if any(r in {"High", "Medium"} for r in risks):
    print(1)
elif any(r in {"Low", "Informational", "Info"} for r in risks):
    print(2)
else:
    print(2)
PY
}

mkdir -p "$OUTPUT_DIR"
ABS_OUTPUT_DIR="$(resolve_abs_path "$OUTPUT_DIR")"
JSON_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.json"
MD_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.md"
HTML_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.html"

echo "Starting DAST runbook..."
echo "  target_url: $TARGET_URL"
echo "  output_dir: $OUTPUT_DIR"
echo "  scan_mode: $SCAN_MODE"
echo "  allow_partial_results: $ALLOW_PARTIAL_RESULTS"
echo "  runner: docker"

SCAN_EXIT_CODE=0
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi
run_docker

echo "  report_json: $JSON_REPORT"
echo "  report_md: $MD_REPORT"
echo "  report_html: $HTML_REPORT"
print_report_summary

if [[ "$SCAN_EXIT_CODE" -gt 2 ]]; then
  if [[ "$ALLOW_PARTIAL_RESULTS" == "true" ]]; then
    if DERIVED_EXIT_CODE="$(derive_exit_code_from_report)"; then
      if [[ "$DERIVED_EXIT_CODE" =~ ^[012]$ ]]; then
        echo "Non-fatal ZAP runtime error detected (exit $SCAN_EXIT_CODE)."
        echo "Using report-derived exit code $DERIVED_EXIT_CODE because DAST_ALLOW_PARTIAL_RESULTS=true."
        SCAN_EXIT_CODE="$DERIVED_EXIT_CODE"
      else
        echo "DAST tool/runtime error (exit $SCAN_EXIT_CODE)." >&2
        exit "$SCAN_EXIT_CODE"
      fi
    else
      echo "DAST tool/runtime error (exit $SCAN_EXIT_CODE)." >&2
      exit "$SCAN_EXIT_CODE"
    fi
  else
    echo "DAST tool/runtime error (exit $SCAN_EXIT_CODE)." >&2
    echo "Set DAST_ALLOW_PARTIAL_RESULTS=true to continue using report-derived status when reports are present." >&2
    exit "$SCAN_EXIT_CODE"
  fi
fi

if [[ "$SCAN_EXIT_CODE" -eq 1 && "$FAIL_ON_FAILS" == "false" ]]; then
  echo "FAIL findings detected, but FAIL_ON_FAILS=false. Continuing with exit 0."
  exit 0
fi

if [[ "$SCAN_EXIT_CODE" -eq 2 && "$FAIL_ON_WARNINGS" == "false" ]]; then
  echo "WARN findings detected, but FAIL_ON_WARNINGS=false. Continuing with exit 0."
  exit 0
fi

exit "$SCAN_EXIT_CODE"
