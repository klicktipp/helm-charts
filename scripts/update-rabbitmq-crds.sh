#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CLUSTER_OPERATOR_CHART="${ROOT_DIR}/charts/rabbitmq-cluster-operator/Chart.yaml"
TOPOLOGY_OPERATOR_CHART="${ROOT_DIR}/charts/rabbitmq-topology-operator/Chart.yaml"

CLUSTER_OPERATOR_VERSION=""
TOPOLOGY_OPERATOR_VERSION=""
CLUSTER_OPERATOR_BASE_URL=""
TOPOLOGY_OPERATOR_BASE_URL=""

CLUSTER_OPERATOR_DEST="${ROOT_DIR}/charts/rabbitmq-cluster-operator/crds"
TOPOLOGY_OPERATOR_DEST="${ROOT_DIR}/charts/rabbitmq-topology-operator/crds"

CLUSTER_OPERATOR_FILES=(
	"rabbitmq.com_rabbitmqclusters.yaml"
)

usage() {
	cat <<'EOF'
Usage: scripts/update-rabbitmq-crds.sh

Downloads the official RabbitMQ CRD files directly from the upstream GitHub repositories
and replaces the vendored files in:
  - charts/rabbitmq-cluster-operator/crds
  - charts/rabbitmq-topology-operator/crds

Environment variables:
  CLUSTER_OPERATOR_VERSION   Optional upstream cluster-operator Git tag override
  TOPOLOGY_OPERATOR_VERSION  Optional upstream messaging-topology-operator Git tag override

Examples:
  scripts/update-rabbitmq-crds.sh
  CLUSTER_OPERATOR_VERSION=v2.19.1 TOPOLOGY_OPERATOR_VERSION=v1.18.3 scripts/update-rabbitmq-crds.sh
EOF
}

require_command() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "Required command not found: $1" >&2
		exit 1
	fi
}

list_github_directory_files() {
	local repo="$1"
	local ref="$2"
	local path="$3"
	local api_url="https://api.github.com/repos/${repo}/contents/${path}?ref=${ref}"

	curl -fsSL "$api_url" | sed -n 's/.*"name": "\([^"]*\.yaml\)".*/\1/p'
}

read_chart_app_version() {
	local chart_file="$1"
	local app_version

	app_version="$(awk -F': *' '$1 == "appVersion" { print $2; exit }' "$chart_file" | tr -d '"')"
	if [[ -z "$app_version" ]]; then
		echo "Could not determine appVersion from ${chart_file}" >&2
		exit 1
	fi

	printf '%s\n' "$app_version"
}

normalize_git_tag() {
	local version="$1"
	if [[ "$version" == v* ]]; then
		printf '%s\n' "$version"
	else
		printf 'v%s\n' "$version"
	fi
}

download_file() {
	local url="$1"
	local dest="$2"
	local tmp_file

	tmp_file="$(mktemp)"
	curl -fsSL "$url" -o "$tmp_file"
	mv "$tmp_file" "$dest"
}

download_group() {
	local base_url="$1"
	local dest_dir="$2"
	shift 2
	local file

	mkdir -p "$dest_dir"

	for file in "$@"; do
		local url="${base_url}/${file}"
		local dest="${dest_dir}/${file}"
		echo "Downloading ${url}"
		download_file "$url" "$dest"
	done
}

main() {
	local topology_operator_files=()
	local topology_file

	if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
		usage
		exit 0
	fi

	require_command curl

	CLUSTER_OPERATOR_VERSION="${CLUSTER_OPERATOR_VERSION:-$(normalize_git_tag "$(read_chart_app_version "$CLUSTER_OPERATOR_CHART")")}"
	TOPOLOGY_OPERATOR_VERSION="${TOPOLOGY_OPERATOR_VERSION:-$(normalize_git_tag "$(read_chart_app_version "$TOPOLOGY_OPERATOR_CHART")")}"

	CLUSTER_OPERATOR_BASE_URL="https://raw.githubusercontent.com/rabbitmq/cluster-operator/${CLUSTER_OPERATOR_VERSION}/config/crd/bases"
	TOPOLOGY_OPERATOR_BASE_URL="https://raw.githubusercontent.com/rabbitmq/messaging-topology-operator/${TOPOLOGY_OPERATOR_VERSION}/config/crd/bases"

	while IFS= read -r topology_file; do
		[[ -n "$topology_file" ]] || continue
		topology_operator_files+=("$topology_file")
	done < <(
		list_github_directory_files \
			"rabbitmq/messaging-topology-operator" \
			"${TOPOLOGY_OPERATOR_VERSION}" \
			"config/crd/bases"
	)

	if [[ "${#topology_operator_files[@]}" -eq 0 ]]; then
		echo "Could not determine topology CRD files from upstream repository" >&2
		exit 1
	fi

	download_group "$CLUSTER_OPERATOR_BASE_URL" "$CLUSTER_OPERATOR_DEST" "${CLUSTER_OPERATOR_FILES[@]}"
	download_group "$TOPOLOGY_OPERATOR_BASE_URL" "$TOPOLOGY_OPERATOR_DEST" "${topology_operator_files[@]}"

	echo
	echo "Updated RabbitMQ CRDs from official upstream sources:"
	echo "  cluster-operator: ${CLUSTER_OPERATOR_VERSION}"
	echo "  messaging-topology-operator: ${TOPOLOGY_OPERATOR_VERSION}"
}

main "$@"
