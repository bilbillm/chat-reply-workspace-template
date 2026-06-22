#!/usr/bin/env bash
set -euo pipefail

destination="${1:-"$HOME/TalkTrace-workspace"}"
alias_name="${2:-}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_root="$(cd "$script_dir/.." && pwd)"

if [ -e "$destination" ] && [ "$(find "$destination" -mindepth 1 -maxdepth 1 | head -n 1)" ]; then
  echo "Destination exists and is not empty: $destination" >&2
  echo "Choose an empty directory." >&2
  exit 1
fi

mkdir -p "$destination"

for item in AGENTS.md README.md README.en.md LICENSE .gitignore assets me people scripts; do
  if [ ! -e "$source_root/$item" ]; then
    echo "Missing required template item: $item" >&2
    exit 1
  fi
  cp -R "$source_root/$item" "$destination/"
done

mkdir -p "$destination/logs" "$destination/raw" "$destination/screenshots" "$destination/exports" "$destination/tmp" "$destination/.tmp_crops"

if [ -n "$alias_name" ]; then
  bash "$destination/scripts/new-person.sh" "$alias_name" "$destination"
fi

cat > "$destination/START_HERE.md" <<'EOF'
# TalkTrace Start Here

Give this to your local agent:

I am using this directory as my TalkTrace workspace. Read AGENTS.md first. Then read me/profile.md, me/style.md, and me/unconscious.md. If I give you a chat object alias, read people/<alias>/profile.md, persona.md, unconscious.md, and style.md before drafting replies. If the alias does not exist, create it from people/_template/.

For a new chat object, run:

```bash
bash scripts/new-person.sh <alias>
```
EOF

echo ""
echo "TalkTrace workspace installed:"
echo "  $destination"
if [ -n "$alias_name" ]; then
  echo "Initialized person alias:"
  echo "  $alias_name"
fi
echo ""
echo "Next command:"
echo "  cd \"$destination\""
echo ""
echo "Then tell your local agent:"
echo "  Read START_HERE.md and AGENTS.md, then help me initialize TalkTrace."
