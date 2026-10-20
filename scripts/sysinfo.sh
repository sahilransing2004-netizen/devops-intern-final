#!/usr/bin/env bash
# sysinfo.sh - report the host environment.
set -euo pipefail

echo "== Host report =="
echo "User:            $(id -un) (effective UID: $(id -u))"
echo "Hostname:        $(hostname)"
echo "Kernel release:  $(uname -r)"
echo "Date (ISO-8601): $(date +%Y-%m-%dT%H:%M:%S%z)"

echo
echo "== Disk usage (human-readable) =="
df -h /

echo
echo "== Memory usage =="
if command -v free >/dev/null 2>&1; then
  free -h
else
  head -n 3 /proc/meminfo
fi

echo
echo "== Docker daemon status =="
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker: not installed"
elif docker info >/dev/null 2>&1; then
  echo "Docker: running (server version $(docker version --format '{{.Server.Version}}'))"
else
  echo "Docker: installed but daemon is not reachable"
fi
