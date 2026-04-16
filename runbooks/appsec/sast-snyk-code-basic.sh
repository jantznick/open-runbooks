#!/usr/bin/env bash
set -euo pipefail

# Basic SAST runbook runner for Snyk Code.
# CI/CD standalone mode:
# - Docker runner only (snyk/snyk:<tag>)
# - No local Snyk CLI installation required
#
# Exit behavior (aligned with snyk CLI):
# - 0: no issues at or above severity threshold (or findings allowed)
# - 1: issues found (when SAST_FAIL_ON_FINDINGS=true)
# - >1: tool/runtime/auth error (see Snyk CLI exit codes)
#
# Requires SNYK_TOKEN in the environment (API token from Snyk).

SCAN_PATH="${SAST_SCAN_PATH:-${SCAN_PATH:-.}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
OUTPUT_FILE="${SAST_OUTPUT_FILE:-${OUTPUT_FILE:-$OUTPUT_DIR/sast-snyk-code.json}}"
FAIL_ON_FINDINGS="${SAST_FAIL_ON_FINDINGS:-${FAIL_ON_FINDINGS:-true}}"
DOCKER_IMAGE="${SAST_SNYK_DOCKER_IMAGE:-${SNYK_DOCKER_IMAGE:-snyk/snyk:node}}"
SEVERITY="${SAST_SNYK_SEVERITY_THRESHOLD:-${SNYK_SEVERITY_THRESHOLD:-high}}"
EXTRA_ARGS="${SAST_SNYK_EXTRA_ARGS:-}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/sast-snyk-code-basic.sh

Required env vars:
  SNYK_TOKEN           Snyk API token (never commit; use CI secrets)

Optional env vars:
  SAST_SCAN_PATH                    Path to scan (default: .)
  SEC_OUTPUT_DIR                    Shared output directory (default: ./artifacts/security)
  SAST_OUTPUT_FILE                  JSON report path (default: $SEC_OUTPUT_DIR/sast-snyk-code.json)
  SAST_FAIL_ON_FINDINGS             true|false (default: true)
  SAST_SNYK_DOCKER_IMAGE            Image tag (default: snyk/snyk:node)
  SAST_SNYK_SEVERITY_THRESHOLD      low|medium|high|critical (default: high)
  SNYK_ORG                          Optional Snyk org slug (passed as --org)
  SAST_SNYK_EXTRA_ARGS              Extra args for `snyk code test` (space-separated)

Legacy env vars still accepted:
  SCAN_PATH, OUTPUT_DIR, OUTPUT_FILE, FAIL_ON_FINDINGS, SNYK_DOCKER_IMAGE, SNYK_SEVERITY_THRESHOLD

Examples:
  SNYK_TOKEN=... ./runbooks/appsec/sast-snyk-code-basic.sh
  SNYK_TOKEN=... SAST_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/sast-snyk-code-basic.sh
  SNYK_TOKEN=... SAST_FAIL_ON_FINDINGS=false ./runbooks/appsec/sast-snyk-code-basic.sh
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ -z "${SNYK_TOKEN:-}" ]]; then
  echo "SNYK_TOKEN is required. Set it to a Snyk API token (use CI secret store in pipelines)." >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"

rel_out="${OUTPUT_FILE#./}"
CONTAINER_JSON="/src/${rel_out}"

rel_scan="${SCAN_PATH#./}"
if [[ "$rel_scan" == "." || -z "$rel_scan" ]]; then
  WORKDIR="/src"
else
  WORKDIR="/src/${rel_scan}"
fi

run_docker_snyk_code() {
  local -a docker_cmd snyk_cmd
  docker_cmd=(docker run --rm -e SNYK_TOKEN -v "$PWD:/src")
  docker_cmd+=(-w "$WORKDIR" "$DOCKER_IMAGE")

  snyk_cmd=(code test)
  if [[ -n "${SNYK_ORG:-}" ]]; then
    snyk_cmd+=(--org="$SNYK_ORG")
  fi
  snyk_cmd+=(--severity-threshold="$SEVERITY" --json-file-output="$CONTAINER_JSON")
  if [[ -n "$EXTRA_ARGS" ]]; then
    # shellcheck disable=SC2206
    snyk_cmd+=($EXTRA_ARGS)
  fi

  set +e
  "${docker_cmd[@]}" "${snyk_cmd[@]}"
  SCAN_EXIT_CODE=$?
  set -e
}

echo "Starting Snyk Code SAST runbook..."
echo "  scan_path: $SCAN_PATH"
echo "  workdir_in_container: $WORKDIR"
echo "  output_file: $OUTPUT_FILE"
echo "  severity_threshold: $SEVERITY"
echo "  fail_on_findings: $FAIL_ON_FINDINGS"
echo "  runner: docker ($DOCKER_IMAGE)"

SCAN_EXIT_CODE=0
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi
run_docker_snyk_code

if [[ "$SCAN_EXIT_CODE" -gt 1 ]]; then
  echo "Snyk Code tool/runtime error (exit $SCAN_EXIT_CODE). See Snyk CLI exit codes." >&2
  exit "$SCAN_EXIT_CODE"
fi

if [[ "$SCAN_EXIT_CODE" -eq 1 && "$FAIL_ON_FINDINGS" == "false" ]]; then
  echo "Findings detected, but SAST_FAIL_ON_FINDINGS=false. Continuing with exit 0."
  exit 0
fi

exit "$SCAN_EXIT_CODE"
