#!/usr/bin/env bash
set -euo pipefail

# Basic SAST runbook runner for Semgrep/OpenGrep.
# CI/CD standalone mode:
# - Docker runner only (returntocorp/semgrep:latest)
# - No local semgrep/opengrep dependency
#
# Exit behavior:
# - 0: no findings (or findings allowed)
# - 1: findings detected (when FAIL_ON_FINDINGS=true)
# - >1: tool/runtime/config error

# Preferred env var names:
# - SAST_SCAN_PATH, SAST_RULESET, SAST_OUTPUT_FILE, SAST_FAIL_ON_FINDINGS
# - SEC_OUTPUT_DIR (shared)
# Backward-compatible fallbacks are still supported.
SCAN_PATH="${SAST_SCAN_PATH:-${SCAN_PATH:-.}}"
RULESET="${SAST_RULESET:-${RULESET:-p/security-audit}}"
OUTPUT_DIR="${SEC_OUTPUT_DIR:-${OUTPUT_DIR:-./artifacts/security}}"
OUTPUT_FILE="${SAST_OUTPUT_FILE:-${OUTPUT_FILE:-$OUTPUT_DIR/sast-results.json}}"
FAIL_ON_FINDINGS="${SAST_FAIL_ON_FINDINGS:-${FAIL_ON_FINDINGS:-true}}"
DOCKER_IMAGE="${SAST_DOCKER_IMAGE:-${DOCKER_IMAGE:-returntocorp/semgrep:latest}}"

usage() {
  cat <<'EOF'
Usage:
  ./runbooks/appsec/sast-semgrep-opengrep-basic.sh

Optional env vars:
  SAST_SCAN_PATH       Path to scan (default: .)
  SAST_RULESET         Rule set/config (default: p/security-audit)
  SEC_OUTPUT_DIR       Shared output directory (default: ./artifacts/security)
  SAST_OUTPUT_FILE     Output file path (default: $SEC_OUTPUT_DIR/sast-results.json)
  SAST_FAIL_ON_FINDINGS true|false (default: true)
  SAST_DOCKER_IMAGE    Docker image (default: returntocorp/semgrep:latest)

Legacy env vars still accepted:
  SCAN_PATH, RULESET, OUTPUT_DIR, OUTPUT_FILE, FAIL_ON_FINDINGS, DOCKER_IMAGE

Examples:
  ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
  SAST_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
  SAST_FAIL_ON_FINDINGS=false ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

mkdir -p "$OUTPUT_DIR"

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

run_docker_semgrep() {
  local container_output_file container_scan_path
  container_output_file="$(to_container_path "$OUTPUT_FILE")"
  container_scan_path="$(to_container_path "$SCAN_PATH")"

  set +e
  docker run --rm \
    -v "$PWD:/src" \
    "$DOCKER_IMAGE" \
    semgrep scan --config "$RULESET" --json --output "$container_output_file" "$container_scan_path"
  SCAN_EXIT_CODE=$?
  set -e
}

echo "Starting SAST runbook..."
echo "  scan_path: $SCAN_PATH"
echo "  ruleset: $RULESET"
echo "  output_file: $OUTPUT_FILE"
echo "  fail_on_findings: $FAIL_ON_FINDINGS"
echo "  runner: docker"

SCAN_EXIT_CODE=0
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required for this standalone CI/CD runbook, but was not found." >&2
  exit 127
fi
run_docker_semgrep

if [[ "$SCAN_EXIT_CODE" -gt 1 ]]; then
  echo "SAST tool/runtime error (exit $SCAN_EXIT_CODE)." >&2
  exit "$SCAN_EXIT_CODE"
fi

if [[ "$SCAN_EXIT_CODE" -eq 1 && "$FAIL_ON_FINDINGS" == "false" ]]; then
  echo "Findings detected, but FAIL_ON_FINDINGS=false. Continuing with exit 0."
  exit 0
fi

exit "$SCAN_EXIT_CODE"
