#!/bin/bash
# Runs the unit tests (Tests/). Extra arguments go to swift test, e.g.
#   scripts/test.sh --filter CounterTests
set -euo pipefail
cd "$(dirname "$0")/.."
swift test "$@"
