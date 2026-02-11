#!/usr/bin/env bash
set -euo pipefail

"$(dirname "$0")/generate-chart-readmes.sh"

if [ "$#" -eq 0 ]; then
  if ! git diff --quiet -- charts/*/README.md; then
    echo "README files are out of date. Run scripts/generate-chart-readmes.sh and commit changes." >&2
    git --no-pager diff -- charts/*/README.md
    exit 1
  fi
else
  for chart_dir in "$@"; do
    readme="${chart_dir%/}/README.md"
    if [ ! -f "$readme" ]; then
      continue
    fi
    if ! git diff --quiet -- "$readme"; then
      echo "README is out of date for ${chart_dir}. Run scripts/generate-chart-readmes.sh and commit changes." >&2
      git --no-pager diff -- "$readme"
      exit 1
    fi
  done
fi

echo "README files are consistent with chart values."
