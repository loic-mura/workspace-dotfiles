#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link_to_home() {
    local src="$1"
    local dest="$HOME/${src#$DOTFILES_DIR/}"

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "  skip  ${src#$DOTFILES_DIR/} (already linked)"
        return
    fi

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "  back  ${src#$DOTFILES_DIR/} → ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
    echo "  link  ${src#$DOTFILES_DIR/}"
}

# Symlink top-level dot-directories (e.g. .claude/)
find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type d -name ".*" -not -name ".git" | while read -r dir; do
    link_to_home "$dir"
done

# Symlink top-level dotfiles (e.g. .gitconfig)
find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type f -name ".*" | while read -r file; do
    link_to_home "$file"
done

echo ""
echo "Done. Dotfiles are now managed by $DOTFILES_DIR"
