#!/usr/bin/env bash

# This script continuously monitors for active TCP connections to a specified ProxySQL service port
# and, if any are found, it pauses execution for a random duration between one and three seconds
# before checking again. It exits when there are no more active connections to the specified port.

set -euo pipefail

PROXYSQL_SERVICE_PORT="${PROXYSQL_SERVICE_PORT:-6033}"
SLEEP_BEFORE_CONNECTION_CHECK="${SLEEP_BEFORE_CONNECTION_CHECK:-15}"
CONNECTION_DRAIN_TIMEOUT_SECONDS="${CONNECTION_DRAIN_TIMEOUT_SECONDS:-0}"
CONNECTION_CHECK_INTERVAL_SECONDS="${CONNECTION_CHECK_INTERVAL_SECONDS:-1}"
TERMINATION_MARKER_FILE="${PROXYSQL_TERMINATION_MARKER_FILE:-/tmp/proxysql-terminating}"

HEX_PORT="$(printf '%04X' "${PROXYSQL_SERVICE_PORT}")"

cleanup() {
  rm -f "${TERMINATION_MARKER_FILE}"
}

trap cleanup EXIT

count_active_connections() {
  local total=0
  local pid
  local c4
  local c6

  for pid in $(pidof proxysql 2>/dev/null || true); do
    if [ -r "/proc/${pid}/net/tcp" ]; then
      c4=$(awk -v p="${HEX_PORT}" '$2 ~ ":" p "$" && $4 == "01" {n++} END {print n+0}' "/proc/${pid}/net/tcp")
      total=$((total + c4))
    fi

    if [ -r "/proc/${pid}/net/tcp6" ]; then
      c6=$(awk -v p="${HEX_PORT}" '$2 ~ ":" p "$" && $4 == "01" {n++} END {print n+0}' "/proc/${pid}/net/tcp6")
      total=$((total + c6))
    fi
  done

  printf '%s\n' "${total}"
}

echo "Waiting for ProxySQL connections to finish..."
touch "${TERMINATION_MARKER_FILE}"
echo "Termination marker set at ${TERMINATION_MARKER_FILE}."
echo "Sleep ${SLEEP_BEFORE_CONNECTION_CHECK}s before checking active connections."
sleep "${SLEEP_BEFORE_CONNECTION_CHECK}"

deadline=0
if [ "${CONNECTION_DRAIN_TIMEOUT_SECONDS}" -gt 0 ]; then
  deadline=$(( $(date +%s) + CONNECTION_DRAIN_TIMEOUT_SECONDS ))
  echo "Maximum drain wait: ${CONNECTION_DRAIN_TIMEOUT_SECONDS}s."
fi

while true; do
  active="$(count_active_connections)"

  if [ "${active}" -eq 0 ]; then
    echo "No active ProxySQL connections. Exiting preStop."
    exit 0
  fi

  if [ "${deadline}" -gt 0 ] && [ "$(date +%s)" -ge "${deadline}" ]; then
    echo "Drain timeout reached with ${active} active connections. Proceeding with termination."
    exit 0
  fi

  echo "Active ProxySQL connections: ${active}. Sleeping ${CONNECTION_CHECK_INTERVAL_SECONDS}s."
  sleep "${CONNECTION_CHECK_INTERVAL_SECONDS}"
done
