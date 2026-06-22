#!/usr/bin/env bash
set -euo pipefail

alias_name="${1:-}"
workspace="${2:-}"

if [ -z "$alias_name" ]; then
  echo "Usage: bash scripts/new-person.sh <alias> [workspace]" >&2
  exit 1
fi

if [ "$alias_name" = "_template" ] || [[ "$alias_name" == *"/"* ]] || [[ "$alias_name" == *"&"* ]]; then
  echo "Invalid alias: $alias_name" >&2
  exit 1
fi

if [ -z "$workspace" ]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  workspace="$(cd "$script_dir/.." && pwd)"
fi

template="$workspace/people/_template"
target="$workspace/people/$alias_name"

if [ ! -d "$template" ]; then
  echo "Missing person template: $template" >&2
  exit 1
fi

if [ -e "$target" ]; then
  echo "Person already exists: $target" >&2
  exit 1
fi

mkdir -p "$target"
cp -R "$template/." "$target/"

for file in "$target"/*.md; do
  [ -f "$file" ] || continue
  tmp="$file.tmp"
  sed "s/<alias>/$alias_name/g" "$file" > "$tmp"
  mv "$tmp" "$file"
done

echo "Initialized TalkTrace person:"
echo "  $target"
echo ""
echo "Next: tell your agent the alias is '$alias_name' and paste the chat context plus your reply goal."
