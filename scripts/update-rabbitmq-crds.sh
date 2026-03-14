#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CLUSTER_OPERATOR_VERSION="${CLUSTER_OPERATOR_VERSION:-v2.19.0}"
TOPOLOGY_OPERATOR_VERSION="${TOPOLOGY_OPERATOR_VERSION:-v1.18.2}"

CLUSTER_OPERATOR_BASE_URL="https://raw.githubusercontent.com/rabbitmq/cluster-operator/${CLUSTER_OPERATOR_VERSION}/config/crd/bases"
TOPOLOGY_OPERATOR_BASE_URL="https://raw.githubusercontent.com/rabbitmq/messaging-topology-operator/${TOPOLOGY_OPERATOR_VERSION}/config/crd/bases"

CLUSTER_OPERATOR_DEST="${ROOT_DIR}/charts/rabbitmq-cluster-operator/crds"
TOPOLOGY_OPERATOR_DEST="${ROOT_DIR}/charts/rabbitmq-topology-operator/crds"

CLUSTER_OPERATOR_FILES=(
  "rabbitmq.com_rabbitmqclusters.yaml"
)

TOPOLOGY_OPERATOR_FILES=(
  "rabbitmq.com_bindings.yaml"
  "rabbitmq.com_exchanges.yaml"
  "rabbitmq.com_federations.yaml"
  "rabbitmq.com_operatorpolicies.yaml"
  "rabbitmq.com_permissions.yaml"
  "rabbitmq.com_policies.yaml"
  "rabbitmq.com_queues.yaml"
  "rabbitmq.com_schemareplications.yaml"
  "rabbitmq.com_shovels.yaml"
  "rabbitmq.com_superstreams.yaml"
  "rabbitmq.com_topicpermissions.yaml"
  "rabbitmq.com_users.yaml"
  "rabbitmq.com_vhosts.yaml"
)

usage() {
  cat <<'EOF'
Usage: scripts/update-rabbitmq-crds.sh

Downloads the official RabbitMQ CRD files directly from the upstream GitHub repositories
and replaces the vendored files in:
  - charts/rabbitmq-cluster-operator/crds
  - charts/rabbitmq-topology-operator/crds

Environment variables:
  CLUSTER_OPERATOR_VERSION   Upstream cluster-operator Git tag, e.g. v2.19.0
  TOPOLOGY_OPERATOR_VERSION  Upstream messaging-topology-operator Git tag, e.g. v1.18.2

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
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  require_command curl

  download_group "$CLUSTER_OPERATOR_BASE_URL" "$CLUSTER_OPERATOR_DEST" "${CLUSTER_OPERATOR_FILES[@]}"
  download_group "$TOPOLOGY_OPERATOR_BASE_URL" "$TOPOLOGY_OPERATOR_DEST" "${TOPOLOGY_OPERATOR_FILES[@]}"

  echo
  echo "Updated RabbitMQ CRDs from official upstream sources:"
  echo "  cluster-operator: ${CLUSTER_OPERATOR_VERSION}"
  echo "  messaging-topology-operator: ${TOPOLOGY_OPERATOR_VERSION}"
}

main "$@"
