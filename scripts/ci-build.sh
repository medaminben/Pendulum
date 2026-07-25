#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PRESET="${1:-ci}"

cmake --preset "$PRESET"
cmake --build --preset "$PRESET" --parallel
ctest --preset "$PRESET" --output-on-failure

if [[ "${ENABLE_COVERAGE_REPORT:-0}" == "1" ]]; then
  cmake --build --preset "$PRESET" --target coverage || true
fi
