#!/bin/bash

# Usage:
#   proxysql_cluster_healthcheck.sh <readiness|liveness|started|test>

set -euo pipefail

PROXYSQL_HEALTHCHECK_VERBOSE="${PROXYSQL_HEALTHCHECK_VERBOSE:-false}"
HEALTHCHECK_STATE_DIR="${PROXYSQL_HEALTHCHECK_STATE_DIR:-/tmp}"
LAST_ERROR=""

# Set the database connection variables
export DB_USER="${PROXYSQL_HEALTHCHECK_DB_USER:-monitor}"
export DB_HOST="${PROXYSQL_HEALTHCHECK_DB_HOST:-127.0.0.1}"
export DB_PORT="${PROXYSQL_HEALTHCHECK_DB_PORT:-6032}"
export MYSQL_PWD="${PROXYSQL_HEALTHCHECK_DB_PASS:-monitor}"

HEALTHCHECK_MODE="${1:-}"

# Health check configuration with default values
PROXYSQL_HEALTHCHECK_DIFF_CHECK_LIMIT=${PROXYSQL_HEALTHCHECK_DIFF_CHECK_LIMIT:-10}
PROXYSQL_HEALTHCHECK_PROXY_HOST="${PROXYSQL_HEALTHCHECK_PROXY_HOST:-127.0.0.1}"
PROXYSQL_HEALTHCHECK_PROXY_PORT="${PROXYSQL_HEALTHCHECK_PROXY_PORT:-{{ .Values.service.proxyPort }}}"

# Locate mysql or mariadb client binary
function find_mysql_client() {
	if command -v mysql >/dev/null 2>&1; then
		echo "mysql"
	elif command -v mariadb >/dev/null 2>&1; then
		echo "mariadb"
	else
		log_error "Neither 'mysql' nor 'mariadb' client is installed."
		exit 1
	fi
}

MYSQL_CLIENT=$(find_mysql_client)

function log_info() {
	local message="$1"
	echo "[$(date -Ins)] [INFO] ${message}"
	write_check_status_file "$HEALTHCHECK_MODE" "passed" "${message}"
}

function log_error() {
	local message="$1"
	echo "[$(date -Ins)] [ERROR] ${message}" >&2
	write_check_status_file "$HEALTHCHECK_MODE" "failed" "${message}"
}

function log_warning() {
	local message="$1"
	echo "[$(date -Ins)] [WARNING] ${message}"
}

function mysql_cli() {
	$MYSQL_CLIENT -u "$DB_USER" -h "$DB_HOST" -P "$DB_PORT" --skip-column-names --batch -e "$1"
}

function write_check_status_file() {
	local mode="$1"
	local status="$2"
	local error_message="${3:-}"
	local status_file="${HEALTHCHECK_STATE_DIR}/proxysql_cluster_healthcheck_${mode}.status"
	local timestamp
	timestamp="$(date -Is)"

	if [[ -n "$error_message" ]]; then
		printf '{"check":"%s","status":"%s","error":"%s","timestamp":"%s"}\n' "$mode" "$status" "$error_message" "$timestamp" >"$status_file"
	else
		printf '{"check":"%s","status":"%s","timestamp":"%s"}\n' "$mode" "$status" "$timestamp" >"$status_file"
	fi
}

function get_current_proxysql_state() {
	if [[ "$PROXYSQL_HEALTHCHECK_VERBOSE" == "true" ]]; then
		local current_state_result
		current_state_result=$(mysql_cli "SELECT hostname, port, name, version, FROM_UNIXTIME(epoch) epoch, checksum, FROM_UNIXTIME(changed_at) changed_at, FROM_UNIXTIME(updated_at) updated_at, diff_check, DATETIME('NOW') FROM stats_proxysql_servers_checksums WHERE diff_check > $PROXYSQL_HEALTHCHECK_DIFF_CHECK_LIMIT ORDER BY name;")
		echo "$current_state_result"
	fi
}

function run_diff_check_count() {
	local diff_check_count
	diff_check_count=$(mysql_cli "SELECT COUNT(diff_check) FROM stats_proxysql_servers_checksums WHERE diff_check > $PROXYSQL_HEALTHCHECK_DIFF_CHECK_LIMIT;")

	if [[ "$diff_check_count" == 0 ]]; then
		log_info "ProxySQL Cluster diff_check OK. diff_check < $PROXYSQL_HEALTHCHECK_DIFF_CHECK_LIMIT"
		return 0
	else
		log_error "ProxySQL Cluster diff_check CRITICAL. diff_check >= $PROXYSQL_HEALTHCHECK_DIFF_CHECK_LIMIT."
		get_current_proxysql_state
		exit 1
	fi
}

function run_valid_config_count() {
	# The query checks how many valid ProxySQL configurations exist, ignoring any that are outdated or incomplete.
	local valid_config_count
	valid_config_count=$(mysql_cli "SELECT COUNT(checksum) FROM stats_proxysql_servers_checksums WHERE version <> 0 AND checksum <> '' AND checksum IS NOT NULL AND checksum <> '0x0000000000000000' ORDER BY name, hostname;")

	# Check if this pod is marked as a core node and if this is its first run
	if [[ "${PROXYSQL_IS_CORE_NODE:-false}" == "true" && "$valid_config_count" -eq 0 ]]; then
		log_info "ProxySQL Core Node initialization in progress. No valid configurations yet."
		return 0
	fi

	if [[ "$valid_config_count" -ge 1 ]]; then
		log_info "ProxySQL Cluster config version and checksum OK. valid_config_count ${valid_config_count} >= 1"
		return 0
	else
		log_error "ProxySQL Cluster config version and checksum CRITICAL. valid_config_count ${valid_config_count} < 1"
		get_current_proxysql_state
		return 1
	fi
}

function run_open_tcp_port_check() {
	if ! bash -c "true <>/dev/tcp/${PROXYSQL_HEALTHCHECK_PROXY_HOST}/${PROXYSQL_HEALTHCHECK_PROXY_PORT}"; then
		log_error "ProxySQL startup check failed."
		exit 1
	fi
	log_info "ProxySQL startup check OK."
}

# Call the health check function once for Kubernetes probes
case "${HEALTHCHECK_MODE}" in
readiness)
	# Can this Pod receive traffic?
	run_valid_config_count
	run_diff_check_count
	log_info "Readiness check passed."
	;;
liveness)
	# Is this container stuck/dead?
	run_open_tcp_port_check
	log_info "Liveness check passed."
	;;
started)
	# Has the app finished starting?
	run_open_tcp_port_check
	log_info "Started check passed."
	;;
test)
	log_info "Running healthcheck in test mode."
	run_valid_config_count
	run_diff_check_count
	log_info "Test check passed."
	;;
*)
	log_error "Unknown healthcheck mode: ${HEALTHCHECK_MODE}"
	exit 1
	;;
esac
