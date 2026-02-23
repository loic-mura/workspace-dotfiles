#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="$HOME/.claude"
TARGETS=(agents skills CLAUDE.md settings.json plugins/installed_plugins.json)

mkdir -p "$CLAUDE_HOME"

for target in "${TARGETS[@]}"; do
    src="$DOTFILES_DIR/.claude/$target"
    dest="$CLAUDE_HOME/$target"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "  skip  $target (already linked)"
        continue
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "  back  $target → ${target}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -sfn "$src" "$dest"
    echo "  link  $target → $src"
done

echo ""
echo "Done. ~/.claude config is now managed by $DOTFILES_DIR"
