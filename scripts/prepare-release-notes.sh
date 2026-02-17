#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <before_sha> <after_sha>" >&2
  exit 1
fi

BEFORE_SHA="$1"
AFTER_SHA="$2"
NOTES_DIR=".release-notes"

mkdir -p "$NOTES_DIR"

sanitize_version() {
  printf '%s' "$1" | tr -d '"' | tr -d "'" | xargs
}

extract_yaml_field_from_file() {
  local file="$1"
  local field="$2"
  awk -F': *' -v key="$field" '$1 == key { print $2; exit }' "$file" | xargs || true
}

extract_yaml_field_from_git() {
  local sha="$1"
  local file="$2"
  local field="$3"
  git show "${sha}:${file}" 2>/dev/null | awk -F': *' -v key="$field" '$1 == key { print $2; exit }' | xargs || true
}

major_part() {
  local version="$1"
  version="$(sanitize_version "$version")"
  printf '%s' "$version" | awk -F'.' '{print $1}'
}

minor_part() {
  local version="$1"
  version="$(sanitize_version "$version")"
  printf '%s' "$version" | awk -F'.' '{print $2}'
}

extract_top_level_keys() {
  local file="$1"
  awk '
    /^[[:space:]]*#/ { next }
    /^[A-Za-z0-9_.-]+:[[:space:]]*($|#)/ {
      key=$1
      sub(/:$/, "", key)
      print key
    }
  ' "$file" | sort -u
}

join_as_bullets() {
  while IFS= read -r item; do
    [ -n "$item" ] && printf -- '- `%s`\n' "$item"
  done
}

render_array_group() {
  local title="$1"
  local arr_name="$2"
  local max_items="$3"
  local len=0
  local i=0
  local item=""
  local limit=0

  eval "len=\${#${arr_name}[@]}"
  if [ "$len" -eq 0 ]; then
    return
  fi

  printf '\n### %s\n' "$title"

  limit="$len"
  if [ "$limit" -gt "$max_items" ]; then
    limit="$max_items"
  fi

  for ((i=0; i<limit; i++)); do
    eval "item=\${${arr_name}[i]}"
    printf -- '- %s\n' "$item"
  done

  if [ "$len" -gt "$max_items" ]; then
    printf -- '- ... and %s more\n' "$((len - max_items))"
  fi
}

find_last_version_change_commit_for_version() {
  local chart_file="$1"
  local target_version="$2"
  local prev_version=""
  local current_version=""
  local commit_sha=""
  local intro_commit=""

  while IFS= read -r commit_sha; do
    [ -z "$commit_sha" ] && continue
    current_version="$(extract_yaml_field_from_git "$commit_sha" "$chart_file" version)"
    current_version="$(sanitize_version "$current_version")"
    [ -z "$current_version" ] && continue

    if [ "$current_version" != "$prev_version" ]; then
      if [ "$current_version" = "$target_version" ]; then
        intro_commit="$commit_sha"
      fi
      prev_version="$current_version"
    fi
  done < <(git log --reverse --format='%H' -- "$chart_file" || true)

  printf '%s' "$intro_commit"
}

extract_merge_pr_title() {
  local commit_sha="$1"
  git show -s --format='%B' "$commit_sha" | awk '
    BEGIN { seen=0 }
    /^Merge pull request #[0-9]+/ { seen=1; next }
    NF && seen == 1 { print; exit }
  '
}

changed_chart_files=()
while IFS= read -r line; do
  [ -n "$line" ] && changed_chart_files+=("$line")
done < <(git diff --name-only "$BEFORE_SHA" "$AFTER_SHA" -- 'charts/*/Chart.yaml' || true)

if [ "${#changed_chart_files[@]}" -eq 0 ]; then
  echo "No chart metadata changes found."
  exit 0
fi

release_tags=()

for chart_file in "${changed_chart_files[@]}"; do
  chart_dir="$(dirname "$chart_file")"
  chart_name="$(basename "$chart_dir")"

  old_version="$(extract_yaml_field_from_git "$BEFORE_SHA" "$chart_file" version)"
  new_version="$(extract_yaml_field_from_file "$chart_file" version)"

  if [ -z "$new_version" ] || [ "$old_version" = "$new_version" ]; then
    continue
  fi

  old_version_clean="$(sanitize_version "$old_version")"
  new_version_clean="$(sanitize_version "$new_version")"

  old_app_version="$(extract_yaml_field_from_git "$BEFORE_SHA" "$chart_file" appVersion)"
  new_app_version="$(extract_yaml_field_from_file "$chart_file" appVersion)"
  old_app_version_clean="$(sanitize_version "$old_app_version")"
  new_app_version_clean="$(sanitize_version "$new_app_version")"

  tag="${chart_name}-${new_version_clean}"
  notes_file="${NOTES_DIR}/${tag}.md"
  release_tags+=("$tag")

  tmp_dir="$(mktemp -d)"
  old_values_file="${tmp_dir}/old-values.yaml"
  new_values_file="${tmp_dir}/new-values.yaml"

  has_values=false
  if git show "${BEFORE_SHA}:${chart_dir}/values.yaml" > "$old_values_file" 2>/dev/null && [ -f "${chart_dir}/values.yaml" ]; then
    cp "${chart_dir}/values.yaml" "$new_values_file"
    has_values=true
  fi

  added_keys=""
  removed_keys=""
  if [ "$has_values" = true ]; then
    old_keys_file="${tmp_dir}/old-keys.txt"
    new_keys_file="${tmp_dir}/new-keys.txt"
    extract_top_level_keys "$old_values_file" > "$old_keys_file"
    extract_top_level_keys "$new_values_file" > "$new_keys_file"

    added_keys="$(comm -13 "$old_keys_file" "$new_keys_file" || true)"
    removed_keys="$(comm -23 "$old_keys_file" "$new_keys_file" || true)"
  fi

  changed_files=()
  while IFS= read -r line; do
    [ -n "$line" ] && changed_files+=("$line")
  done < <(git diff --name-only "$BEFORE_SHA" "$AFTER_SHA" -- "${chart_dir}" || true)

  changed_templates=()
  while IFS= read -r line; do
    [ -n "$line" ] && changed_templates+=("$line")
  done < <(printf '%s\n' "${changed_files[@]}" | grep -E "^${chart_dir}/templates/" || true)

  changed_chart_files_local=()
  while IFS= read -r line; do
    [ -n "$line" ] && changed_chart_files_local+=("$line")
  done < <(printf '%s\n' "${changed_files[@]}" | grep -E "^${chart_dir}/(files|crds)/" || true)

  breaking_items=()
  feature_items=()
  fix_items=()
  pr_commits=()
  standalone_commits=()

  old_major="$(major_part "$old_version_clean")"
  new_major="$(major_part "$new_version_clean")"
  old_minor="$(minor_part "$old_version_clean")"
  new_minor="$(minor_part "$new_version_clean")"

  if [ -n "$old_major" ] && [ -n "$new_major" ] && [ "$new_major" -gt "$old_major" ]; then
    breaking_items+=("Chart major version bump: ${old_version_clean:-n/a} -> ${new_version_clean}")
  fi

  if [ -n "$removed_keys" ]; then
    while IFS= read -r key; do
      [ -n "$key" ] && breaking_items+=("Removed top-level value: ${key}")
    done <<< "$removed_keys"
  fi

  if [ -n "$added_keys" ]; then
    while IFS= read -r key; do
      [ -n "$key" ] && feature_items+=("New top-level value: ${key}")
    done <<< "$added_keys"
  fi

  if [ -n "$old_minor" ] && [ -n "$new_minor" ] && [ "$new_minor" -gt "$old_minor" ]; then
    feature_items+=("Minor chart version bump: ${old_version_clean:-n/a} -> ${new_version_clean}")
  fi

  if [ "$old_app_version_clean" != "$new_app_version_clean" ] && [ -n "$new_app_version_clean" ]; then
    feature_items+=("App version update: ${old_app_version_clean:-n/a} -> ${new_app_version_clean}")
  fi

  if [ "${#changed_templates[@]}" -gt 0 ]; then
    fix_items+=("Template updates: ${#changed_templates[@]} file(s)")
  fi

  if [ "${#changed_chart_files_local[@]}" -gt 0 ]; then
    fix_items+=("Runtime/supporting files updated: ${#changed_chart_files_local[@]} file(s)")
  fi

  if [ "${#fix_items[@]}" -eq 0 ] && [ "${#feature_items[@]}" -eq 0 ] && [ "${#breaking_items[@]}" -eq 0 ]; then
    fix_items+=("Chart metadata and/or docs adjusted")
  fi

  commit_range_start="$(find_last_version_change_commit_for_version "$chart_file" "$old_version_clean")"
  commit_range="${BEFORE_SHA}..${AFTER_SHA}"
  if [ -n "$commit_range_start" ]; then
    commit_range="${commit_range_start}..${AFTER_SHA}"
  fi

  while IFS=$'\t' read -r commit_sha_full commit_sha_short commit_subject; do
    [ -z "$commit_sha_full" ] && continue
    [ -z "$commit_sha_short" ] && continue
    [ -z "$commit_subject" ] && continue

    if printf '%s\n' "$commit_subject" | grep -Eq '^Merge pull request #[0-9]+'; then
      pr_number="$(printf '%s\n' "$commit_subject" | sed -E 's/^Merge pull request #([0-9]+).*/\1/')"
      pr_title="$(extract_merge_pr_title "$commit_sha_full")"
      if [ -z "$pr_title" ]; then
        pr_title="$commit_subject"
      fi
      pr_commits+=("\`${commit_sha_short}\` PR #${pr_number}: ${pr_title}")
      continue
    fi

    if printf '%s\n' "$commit_subject" | grep -Eq ' \(#[0-9]+\)$'; then
      pr_number="$(printf '%s\n' "$commit_subject" | sed -E 's/.* \(#([0-9]+)\)$/\1/')"
      pr_title="$(printf '%s\n' "$commit_subject" | sed -E 's/ \(#[0-9]+\)$//')"
      pr_commits+=("\`${commit_sha_short}\` PR #${pr_number}: ${pr_title}")
      continue
    fi

    standalone_commits+=("\`${commit_sha_short}\` ${commit_subject}")
  done < <(git log --first-parent --reverse --pretty=format:'%H%x09%h%x09%s' "${commit_range}" -- "${chart_dir}" || true)

  total_commit_count=$(( ${#pr_commits[@]} + ${#standalone_commits[@]} ))

  {
    printf '# %s %s\n\n' "$chart_name" "$new_version_clean"
    printf '## Highlights\n'
    printf -- '- Chart version: `%s` -> `%s`\n' "${old_version_clean:-n/a}" "$new_version_clean"
    if [ -n "$new_app_version_clean" ] || [ -n "$old_app_version_clean" ]; then
      printf -- '- App version: `%s` -> `%s`\n' "${old_app_version_clean:-n/a}" "${new_app_version_clean:-n/a}"
    fi

    if [ "${#breaking_items[@]}" -gt 0 ]; then
      printf '\n## Breaking Changes\n'
      printf '%s\n' "${breaking_items[@]}" | join_as_bullets
    fi

    if [ "${#feature_items[@]}" -gt 0 ]; then
      printf '\n## Features\n'
      printf '%s\n' "${feature_items[@]}" | join_as_bullets
    fi

    if [ "${#fix_items[@]}" -gt 0 ]; then
      printf '\n## Fixes & Internal Changes\n'
      printf '%s\n' "${fix_items[@]}" | join_as_bullets
    fi

    printf '\n## Changed Files\n'
    if [ "${#changed_files[@]}" -gt 0 ]; then
      printf '%s\n' "${changed_files[@]}" | sed "s#^${chart_dir}/#- `#; s#\$#`#"
    else
      printf -- '- No file-level changes detected in `%s`.\n' "$chart_dir"
    fi

    printf '\n## Commit Summary\n'
    if [ "$total_commit_count" -gt 0 ]; then
      if [ -n "$commit_range_start" ]; then
        printf -- '- Window: commits touching `%s` since last version change (`%s`) to `%s`\n' "$chart_dir" "${old_version_clean:-n/a}" "$new_version_clean"
      else
        printf -- '- Window: commits touching `%s` in current release range `%s`\n' "$chart_dir" "${commit_range}"
      fi
      printf -- '- Included commits: %s\n' "$total_commit_count"
      render_array_group "Pull Request Commits (Primary)" pr_commits 12
      render_array_group "Standalone Commits" standalone_commits 10
    else
      printf -- '- No commits detected for `%s` in this release window.\n' "$chart_dir"
    fi

    printf '\n## Upgrade Notes\n'
    printf -- '- Review your values against this release before rollout.\n'
    if [ -n "$removed_keys" ]; then
      printf -- '- Removed keys require cleanup in your values files.\n'
    fi
  } > "$notes_file"

  rm -rf "$tmp_dir"
  echo "Prepared release notes: ${notes_file}"
done

if [ "${#release_tags[@]}" -gt 0 ] && [ -n "${GITHUB_OUTPUT:-}" ]; then
  {
    printf 'release_tags<<EOF\n'
    printf '%s\n' "${release_tags[@]}"
    printf 'EOF\n'
  } >> "$GITHUB_OUTPUT"
fi
