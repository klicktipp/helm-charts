#!/usr/bin/env python3
"""Validate values.yaml parameter documentation comments.

Rule set (pragmatic for helm-docs style):
- Values keys should be documented with `# -- ...` comments.
- Leaf keys are considered documented if they have a local `# --` comment block
  directly above, or any documented ancestor has one.
- This allows concise docs at section level while still catching undocumented
  parameter trees.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys
from dataclasses import dataclass

KEY_RE = re.compile(r"^(\s*)([A-Za-z0-9_.-]+):(?:\s*(.*))?$")
DOC_RE = re.compile(r"^\s*#\s*--\s*\S+")


@dataclass
class Entry:
    path: str
    indent: int
    line: int
    documented_self: bool


def has_doc_comment(lines: list[str], idx: int) -> bool:
    found_comment_block = False
    documented = False

    j = idx - 1
    while j >= 0:
        raw = lines[j]
        stripped = raw.strip()

        if stripped == "":
            if found_comment_block:
                break
            j -= 1
            continue

        if raw.lstrip().startswith("#"):
            found_comment_block = True
            if DOC_RE.match(raw):
                documented = True
            j -= 1
            continue

        break

    return documented


def collect_entries(values_file: pathlib.Path) -> list[Entry]:
    lines = values_file.read_text(encoding="utf-8").splitlines()
    entries: list[Entry] = []
    stack: list[tuple[int, str]] = []

    block_scalar_indent: int | None = None

    for i, raw in enumerate(lines):
        stripped = raw.strip()

        if block_scalar_indent is not None:
            if stripped == "":
                continue
            current_indent = len(raw) - len(raw.lstrip(" "))
            if current_indent > block_scalar_indent:
                continue
            block_scalar_indent = None

        if stripped == "" or stripped.startswith("#") or stripped == "---" or stripped == "...":
            continue
        if stripped.startswith("- "):
            continue

        m = KEY_RE.match(raw)
        if not m:
            continue

        indent = len(m.group(1).replace("\t", "    "))
        key = m.group(2)
        value_part = (m.group(3) or "").strip()

        while stack and stack[-1][0] >= indent:
            stack.pop()

        path = ".".join([k for _, k in stack] + [key])
        documented_self = has_doc_comment(lines, i)
        entries.append(Entry(path=path, indent=indent, line=i + 1, documented_self=documented_self))
        stack.append((indent, key))

        if value_part in {"|", "|-", "|+", ">", ">-", ">+"}:
            block_scalar_indent = indent

    return entries


def find_undocumented_leaf_params(entries: list[Entry]) -> list[Entry]:
    documented_paths = {e.path for e in entries if e.documented_self}

    undocumented: list[Entry] = []
    for idx, entry in enumerate(entries):
        has_child = idx + 1 < len(entries) and entries[idx + 1].indent > entry.indent
        if has_child:
            continue

        segments = entry.path.split(".")
        documented = False
        for i in range(1, len(segments) + 1):
            prefix = ".".join(segments[:i])
            if prefix in documented_paths:
                documented = True
                break

        if not documented:
            undocumented.append(entry)

    return undocumented


def check_file(values_file: pathlib.Path) -> tuple[bool, list[str]]:
    entries = collect_entries(values_file)
    undocumented = find_undocumented_leaf_params(entries)

    if not undocumented:
        return True, []

    errors = [f"{values_file}:{e.line}: missing documentation comment (# -- ...) for '{e.path}'" for e in undocumented]
    return False, errors


def discover_values_files(root: pathlib.Path) -> list[pathlib.Path]:
    files: list[pathlib.Path] = []
    for chart_yaml in sorted(root.glob("charts/*/Chart.yaml")):
        values_yaml = chart_yaml.parent / "values.yaml"
        if values_yaml.exists():
            files.append(values_yaml)
    return files


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("files", nargs="*", type=pathlib.Path, help="values.yaml files to check")
    args = parser.parse_args()

    files = args.files if args.files else discover_values_files(pathlib.Path("."))
    if not files:
        print("No values.yaml files found.")
        return 0

    all_errors: list[str] = []
    for file in files:
        ok, errors = check_file(file)
        if not ok:
            all_errors.extend(errors)

    if all_errors:
        print("Values documentation check failed:", file=sys.stderr)
        for err in all_errors:
            print(f"  - {err}", file=sys.stderr)
        return 1

    print("Values documentation check passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
