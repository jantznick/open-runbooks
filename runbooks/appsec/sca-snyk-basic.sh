#!/usr/bin/env bash
set -euo pipefail

# Basic SCA runbook runner for Snyk Open Source (snyk test).
# CI/CD standalone mode:
# - Docker runner only (snyk/snyk:<tag>)
# - No local Snyk CLI installation required
#
# Requires SNYK_TOKEN in the environment (API token from Snyk).
#
# Note: Some ecosystems resolve dependencies more accurately after install (for example npm ci).
# If results look incomplete, add a dependency-install step before this script in CI.

SCAN_PATH="${SCA_SCAN_PATH:-${SCAN_PATH:-.}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
REPORT_PREFIX="${SCA_REPORT_PREFIX:-${REPORT_PREFIX:-sca-snyk}}"
IMAGE="${SCA_SNYK_DOCKER_IMAGE:-${SNYK_DOCKER_IMAGE:-snyk/snyk:node}}"
FAIL_ON_FAILS="${SCA_FAIL_ON_FAILS:-${FAIL_ON_FAILS:-true}}"
SEVERITY="${SCA_SNYK_SEVERITY_THRESHOLD:-${SNYK_SEVERITY_THRESHOLD:-high}}"
ALL_PROJECTS="${SCA_SNYK_ALL_PROJECTS:-false}"
EXTRA_ARGS="${SCA_SNYK_EXTRA_ARGS:-}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/sca-snyk-basic.sh [options]

Required env vars:
  SNYK_TOKEN           Snyk API token (never commit; use CI secrets)

Options:
  --scan-path <path>         Path to scan (default: .)
  --output-dir <dir>         Output directory (default: ./artifacts/security)
  --report-prefix <name>     Report filename prefix without .json (default: sca-snyk)
  --help                     Show this help

Optional env vars:
  SCA_SCAN_PATH                    Path to scan (default: .)
  SEC_OUTPUT_DIR                   Shared output directory (default: ./artifacts/security)
  SCA_REPORT_PREFIX                Report prefix (default: sca-snyk)
  SCA_SNYK_DOCKER_IMAGE            Image tag (default: snyk/snyk:node)
  SCA_FAIL_ON_FAILS                true|false (default: true)
  SCA_SNYK_SEVERITY_THRESHOLD      low|medium|high|critical (default: high)
  SCA_SNYK_ALL_PROJECTS            true|false — add --all-projects (default: false)
  SNYK_ORG                         Optional Snyk org slug (passed as --org)
  SCA_SNYK_EXTRA_ARGS              Extra args for `snyk test` (space-separated)

Legacy env vars still accepted:
  SCAN_PATH, OUTPUT_DIR, REPORT_PREFIX, FAIL_ON_FAILS, SNYK_DOCKER_IMAGE, SNYK_SEVERITY_THRESHOLD
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

if [[ -z "${SNYK_TOKEN:-}" ]]; then
  echo "SNYK_TOKEN is required. Set it to a Snyk API token (use CI secret store in pipelines)." >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
JSON_REPORT="$OUTPUT_DIR/$REPORT_PREFIX.json"

rel_out="${JSON_REPORT#./}"
CONTAINER_JSON="/src/${rel_out}"

rel_scan="${SCAN_PATH#./}"
if [[ "$rel_scan" == "." || -z "$rel_scan" ]]; then
  WORKDIR="/src"
else
  WORKDIR="/src/${rel_scan}"
fi

run_docker_snyk_test() {
  local -a docker_cmd snyk_cmd
  docker_cmd=(docker run --rm -e SNYK_TOKEN -v "$PWD:/src")
  docker_cmd+=(-w "$WORKDIR" "$IMAGE")

  snyk_cmd=(test)
  if [[ -n "${SNYK_ORG:-}" ]]; then
    snyk_cmd+=(--org="$SNYK_ORG")
  fi
  snyk_cmd+=(--severity-threshold="$SEVERITY" --json-file-output="$CONTAINER_JSON")
  if [[ "$ALL_PROJECTS" == "true" ]]; then
    snyk_cmd+=(--all-projects)
  fi
  if [[ -n "$EXTRA_ARGS" ]]; then
    # shellcheck disable=SC2206
    snyk_cmd+=($EXTRA_ARGS)
  fi

  set +e
  "${docker_cmd[@]}" "${snyk_cmd[@]}"
  SCAN_EXIT_CODE=$?
  set -e
}

echo "Starting Snyk Open Source SCA runbook..."
echo "  scan_path: $SCAN_PATH"
echo "  workdir_in_container: $WORKDIR"
echo "  report_json: $JSON_REPORT"
echo "  severity_threshold: $SEVERITY"
echo "  all_projects: $ALL_PROJECTS"
echo "  fail_on_fails: $FAIL_ON_FAILS"
echo "  runner: docker ($IMAGE)"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi

run_docker_snyk_test

if [[ "$SCAN_EXIT_CODE" -gt 1 ]]; then
  echo "Snyk test tool/runtime error (exit $SCAN_EXIT_CODE). See Snyk CLI exit codes." >&2
  exit "$SCAN_EXIT_CODE"
fi

if [[ "$SCAN_EXIT_CODE" -eq 1 ]]; then
  if [[ "$FAIL_ON_FAILS" == "false" ]]; then
    echo "Vulnerable dependencies reported, but SCA_FAIL_ON_FAILS=false. Continuing with exit 0."
    exit 0
  fi
  exit 1
fi

exit 0
