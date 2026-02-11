#!/usr/bin/env bash
set -euo pipefail

if ! command -v helm-docs >/dev/null 2>&1; then
  echo "helm-docs is required but not installed." >&2
  echo "Install: go install github.com/norwoodj/helm-docs/cmd/helm-docs@v1.14.2" >&2
  exit 1
fi

helm-docs --chart-search-root charts --sort-values-order=file
