#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="
echo "Source: $DOTFILES_DIR"

# Fonts installation
echo ""
echo "[fonts] Installing required fonts..."

if command -v brew &> /dev/null; then
  # Use Homebrew on macOS
  if ! brew list --cask font-jetbrains-mono-nerd-font &> /dev/null; then
    echo "  Installing JetBrains Mono Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font
  else
    echo "  ✓ JetBrains Mono Nerd Font already installed"
  fi

  if ! brew list --cask font-noto-sans-mono-cjk-kr &> /dev/null; then
    echo "  Installing Noto Sans Mono CJK KR..."
    brew install --cask font-noto-sans-mono-cjk-kr
  else
    echo "  ✓ Noto Sans Mono CJK KR already installed"
  fi
else
  # Fallback to manual installation on Linux
  if [[ "$(uname)" == "Darwin" ]]; then
    FONT_DIR="$HOME/Library/Fonts"
  else
    FONT_DIR="$HOME/.local/share/fonts"
  fi
  mkdir -p "$FONT_DIR"

  # JetBrains Mono Nerd Font
  if ! fc-list 2>/dev/null | grep -q "JetBrainsMonoNL Nerd Font" && ! ls "$FONT_DIR" 2>/dev/null | grep -q "JetBrainsMono"; then
    echo "  Installing JetBrains Mono Nerd Font..."
    TEMP_DIR=$(mktemp -d)
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip -o "$TEMP_DIR/JetBrainsMono.zip"
    unzip -q "$TEMP_DIR/JetBrainsMono.zip" -d "$TEMP_DIR/JetBrainsMono"
    cp "$TEMP_DIR/JetBrainsMono"/*.ttf "$FONT_DIR/" 2>/dev/null || true
    rm -rf "$TEMP_DIR"
    echo "  ✓ JetBrains Mono Nerd Font installed"
  else
    echo "  ✓ JetBrains Mono Nerd Font already installed"
  fi

  # Noto Sans Mono CJK KR (manual installation for Linux)
  echo "  Warning: Homebrew not found. Please install Noto Sans Mono CJK KR manually on Linux"

  # Refresh font cache (Linux only)
  if command -v fc-cache &> /dev/null; then
    fc-cache -f "$FONT_DIR"
  fi
fi

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
ln -sf "$DOTFILES_DIR/nvim/lua/config/autocmds.lua" ~/.config/nvim/lua/config/autocmds.lua
ln -sf "$DOTFILES_DIR/nvim/lua/plugins/mason.lua" ~/.config/nvim/lua/plugins/mason.lua
ln -sf "$DOTFILES_DIR/nvim/lua/plugins/vim-visual-multi.lua" ~/.config/nvim/lua/plugins/vim-visual-multi.lua
ln -sf "$DOTFILES_DIR/nvim/lua/plugins/git-conflict.lua" ~/.config/nvim/lua/plugins/git-conflict.lua
ln -sf "$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua" ~/.config/nvim/lua/plugins/colorscheme.lua

# ghostty
echo "[ghostty] Linking config..."
if [[ "$(uname)" == "Darwin" ]]; then
  GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
else
  GHOSTTY_DIR="$HOME/.config/ghostty"
fi
mkdir -p "$GHOSTTY_DIR"
ln -sf "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_DIR/config"

# claude-aliases.zsh
echo ""
CLAUDE_ALIASES="$DOTFILES_DIR/claude-aliases.zsh"
SOURCE_LINE="[ -f $CLAUDE_ALIASES ] && source $CLAUDE_ALIASES"

if [ -f "$CLAUDE_ALIASES" ]; then
  echo "✅ claude-aliases.zsh found"
else
  echo "⚠️  claude-aliases.zsh not found at $CLAUDE_ALIASES"
fi

if grep -qF "claude-aliases.zsh" ~/.zshrc 2>/dev/null; then
  echo "⏭️  Already configured in ~/.zshrc"
else
  echo "$SOURCE_LINE" >> ~/.zshrc
  echo "✅ Added source line to ~/.zshrc"
fi

# zshenv (Homebrew PATH for non-interactive shells — needed by mosh-server, etc.)
echo ""
echo "[zshenv] Linking .zshenv..."
ln -sf "$DOTFILES_DIR/mosh/.zshenv" ~/.zshenv

# TPM (Tmux Plugin Manager)
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "[tpm] Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "[tpm] Already installed"
fi

echo ""
echo "=== Done ==="
echo "🎉 Setup complete! Run: source ~/.zshrc"
echo "Next steps:"
echo "  1. source ~/.zshrc  (or open a new terminal)"
echo "  2. Restart tmux"
echo "  3. Press prefix + I in tmux to install plugins"
echo "  4. Restart Neovim to install plugins"
