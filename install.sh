#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if [[ "$(uname -s)" == "Darwin" ]]; then
  command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  xcode-select --install 2>/dev/null || true
  brew install git stow neovim tmux fzf ranger lazygit python3 node zsh go
else
  sudo apt update
  sudo apt install -y git stow curl unzip zsh tmux python3 python3-venv ranger make gcc nodejs npm golang

  curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo tar -C /opt -xzf /tmp/nvim.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin
fi

cd "$DOTFILES"
for dir in */; do
  stow "$(basename "$dir")" -d . -t ~/ -v
done

if [[ "$SHELL" != */zsh ]]; then
  sudo chsh -s "$(command -v zsh)" "$USER"
fi

echo "Done! Run 'exec zsh' to reload your shell."
