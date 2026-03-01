#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
LANE="dev"
SKIP_DOCTOR="false"
DOCTOR_FIX="true"

usage() {
  cat <<USAGE
Usage:
  fastlane_run.sh [--project /abs/path] [--lane dev] [--skip-doctor] [--no-fix]

Options:
  --project      Project root path (default: current dir)
  --lane         Fastlane lane under ios platform (default: dev)
  --skip-doctor  Skip doctor preflight
  --no-fix       Do not auto-fix during doctor
  --help         Show help

Examples:
  fastlane_run.sh --lane dev
  fastlane_run.sh --project /path/to/app --lane dis
  fastlane_run.sh --lane prod --skip-doctor
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT_DIR="$2"; shift 2 ;;
    --lane) LANE="$2"; shift 2 ;;
    --skip-doctor) SKIP_DOCTOR="true"; shift ;;
    --no-fix) DOCTOR_FIX="false"; shift ;;
    --help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "[FAIL] project path not found: $PROJECT_DIR" >&2
  exit 1
fi

cd "$PROJECT_DIR"

if [[ "$SKIP_DOCTOR" != "true" ]]; then
  if [[ "$DOCTOR_FIX" == "true" ]]; then
    bash "$SCRIPT_DIR/doctor_fastlane_env.sh" --project "$PROJECT_DIR" --fix
  else
    bash "$SCRIPT_DIR/doctor_fastlane_env.sh" --project "$PROJECT_DIR"
  fi
fi

echo "[RUN ] bundle exec fastlane ios $LANE"
FASTLANE_SKIP_UPDATE_CHECK=1 FASTLANE_DISABLE_COLORS=1 CI=1 bundle exec fastlane ios "$LANE"
