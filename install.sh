#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$(uname -s)" = "Darwin" ]; then
  # macOS
  brew install bat
  brew install delta-git
  brew install git-absorb
  brew install neovim
elif [ "$(uname -s)" = "Linux" ]; then
  # Linux
  sudo apt install bat
  # Need alias bat=batcat
  #
  # Install delta-git
  curl -sL $(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]*amd64\.deb') -o /tmp/delta.deb
  sudo dpkg -i /tmp/delta.deb
  rm /tmp/delta.deb
  sudo apt-get install neovim/c;
  # Install git-absorb from GitHub release (no .deb available)
  curl -sL $(curl -s https://api.github.com/repos/tummychow/git-absorb/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]*x86_64-unknown-linux-musl\.tar\.gz') -o /tmp/git-absorb.tar.gz
  tar -xzf /tmp/git-absorb.tar.gz -C /tmp
  sudo mv /tmp/git-absorb-*/git-absorb /usr/local/bin/
  rm -rf /tmp/git-absorb.tar.gz /tmp/git-absorb-*
fi

# Install tools
sudo apt-get update -qq
for pkg in git-delta bat; do
    if dpkg -s "$pkg" &>/dev/null; then
        echo "  skip  $pkg (already installed)"
    else
        echo "  install  $pkg"
        sudo apt-get install -y -qq "$pkg"
    fi
done

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
