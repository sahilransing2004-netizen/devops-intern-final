#!/usr/bin/env bash
# healthcheck.sh - assert that a URL returns HTTP 200.
# Usage: healthcheck.sh [URL]    (default: http://localhost:8080)
# Exit codes: 0 = healthy, 1 = unhealthy / unreachable, 2 = curl missing
set -euo pipefail

url="${1:-http://localhost:8080}"

if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl is required but not installed" >&2
  exit 2
fi

status="$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$url" || true)"

if [ "$status" = "200" ]; then
  echo "OK: $url returned HTTP 200"
  exit 0
fi

if [ -z "$status" ] || [ "$status" = "000" ]; then
  echo "FAIL: $url is unreachable (no HTTP response)" >&2
else
  echo "FAIL: $url returned HTTP $status (expected 200)" >&2
fi
exit 1
