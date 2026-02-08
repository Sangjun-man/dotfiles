#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="
echo "Source: $DOTFILES_DIR"

# tmux
echo ""
echo "[tmux] Linking .tmux.conf..."
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

# nvim
echo "[nvim] Linking config files..."
mkdir -p ~/.config/nvim/lua/config ~/.config/nvim/lua/plugins
ln -sf "$DOTFILES_DIR/nvim/lua/config/options.lua" ~/.config/nvim/lua/config/options.lua
ln -sf "$DOTFILES_DIR/nvim/lua/plugins/tmux-navigator.lua" ~/.config/nvim/lua/plugins/tmux-navigator.lua
ln -sf "$DOTFILES_DIR/nvim/lua/plugins/obsidian.lua" ~/.config/nvim/lua/plugins/obsidian.lua

# ghostty (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
  echo "[ghostty] Linking config..."
  GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
  mkdir -p "$GHOSTTY_DIR"
  ln -sf "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_DIR/config"
fi

# TPM (Tmux Plugin Manager)
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "[tpm] Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "[tpm] Already installed"
fi

echo ""
echo "=== Done ==="
echo "Next steps:"
echo "  1. Restart tmux"
echo "  2. Press prefix + I in tmux to install plugins"
echo "  3. Restart Neovim to install plugins"
