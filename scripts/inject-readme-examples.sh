#!/usr/bin/env bash
set -euo pipefail

CHART_ROOT="${1:-charts}"

for chart_dir in "$CHART_ROOT"/*; do
  [[ -d "$chart_dir" ]] || continue

  readme="$chart_dir/README.md"
  examples_dir="$chart_dir/examples"

  [[ -f "$readme" ]] || continue
  [[ -d "$examples_dir" ]] || continue
  grep -q "<!-- BEGIN AUTO EXAMPLES -->" "$readme" || continue
  grep -q "<!-- END AUTO EXAMPLES -->" "$readme" || continue

  files_tmp="$(mktemp)"
  find "$examples_dir" -maxdepth 1 -type f \( -name "*.yaml" -o -name "*.yml" \) | sort >"$files_tmp"

  tmp_block="$(mktemp)"
  {
    echo "## Examples"
    echo

    if [[ ! -s "$files_tmp" ]]; then
      echo "_No examples defined._"
      echo
    else
      idx=1
      while IFS= read -r file; do
        title="$(sed -n '1{s/^# *[Tt]itle:[[:space:]]*//p;q;}' "$file")"
        if [[ -z "$title" ]]; then
          base="$(basename "$file")"
          title="${base%.*}"
        fi

        description="$(sed -n 's/^# *[Dd]escription:[[:space:]]*//p' "$file" | head -n1)"

        echo "### ${idx}. ${title}"
        echo
        if [[ -n "$description" ]]; then
          echo "$description"
          echo
        fi
        echo '```yaml'
        awk '!(NR <= 5 && $0 ~ /^# *([Tt]itle|[Dd]escription):/)' "$file"
        echo '```'
        echo
        idx=$((idx + 1))
      done <"$files_tmp"
    fi
  } >"$tmp_block"

  tmp_out="$(mktemp)"
  awk -v insert_file="$tmp_block" '
    /<!-- BEGIN AUTO EXAMPLES -->/ {
      print
      while ((getline line < insert_file) > 0) print line
      close(insert_file)
      in_block = 1
      next
    }
    /<!-- END AUTO EXAMPLES -->/ {
      in_block = 0
      print
      next
    }
    !in_block { print }
  ' "$readme" >"$tmp_out"

  mv "$tmp_out" "$readme"
  rm -f "$files_tmp"
  rm -f "$tmp_block"
done
