#!/bin/bash

# ============================================================
# Mac Mini Setup Script — AyeEye Workstation
# Run this on a fresh macOS with username "helrabelo"
#
# Prerequisites:
#   1. Sign in to Apple ID (iCloud, App Store)
#   2. Open Terminal.app
#   3. Run: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#   4. Clone this repo: git clone <dotfiles-repo> ~/code/dotfiles
#   5. Run this script: bash ~/code/dotfiles/mac-mini-setup.sh
# ============================================================

set -e

echo "=== Mac Mini Setup: AyeEye Workstation ==="
echo ""

# ------------------------------------------------------------------
# 1. Homebrew packages (essential dev tools only — keep Mini lean)
# ------------------------------------------------------------------
echo ">>> Installing Homebrew packages..."

# Core dev tools
brew install git direnv fd fzf neovim tmux tree-sitter zoxide

# Languages & runtimes
brew install go rbenv

# Node.js via nvm (installed separately below)
# Python via uv/rye (installed separately below)

# Utilities
brew install gnupg pinentry-mac pngpaste imagemagick

# Casks — essential apps only
brew install --cask 1password-cli
brew install --cask orbstack       # Docker alternative (lightweight)
brew install --cask ngrok

echo ""

# ------------------------------------------------------------------
# 2. Oh My Zsh + Spaceship prompt
# ------------------------------------------------------------------
echo ">>> Setting up Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Spaceship theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" ]; then
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
    ln -s "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme" 2>/dev/null || true
fi

# Zinit (zsh plugin manager)
if [ ! -d "$HOME/.zinit" ]; then
    mkdir -p "$HOME/.zinit"
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
fi

echo ""

# ------------------------------------------------------------------
# 3. Node.js (nvm)
# ------------------------------------------------------------------
echo ">>> Setting up nvm + Node.js..."

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 22  # LTS — match your MacBook
nvm alias default 22

# pnpm
npm install -g pnpm

echo ""

# ------------------------------------------------------------------
# 4. Python (uv + rye)
# ------------------------------------------------------------------
echo ">>> Setting up Python tooling..."

# uv (fast Python package manager)
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# rye (Python project manager)
if ! command -v rye &>/dev/null; then
    curl -sSf https://rye.astral.sh/get | bash
fi

echo ""

# ------------------------------------------------------------------
# 5. Ruby (rbenv)
# ------------------------------------------------------------------
echo ">>> Setting up Ruby..."

if command -v rbenv &>/dev/null; then
    rbenv install 3.4.1 --skip-existing
    rbenv global 3.4.1
fi

echo ""

# ------------------------------------------------------------------
# 6. Claude Code
# ------------------------------------------------------------------
echo ">>> Installing Claude Code..."

if ! command -v claude &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
fi

echo ""

# ------------------------------------------------------------------
# 7. Dotfiles symlinks (shell, git, claude, nvim)
# ------------------------------------------------------------------
echo ">>> Running dotfiles setup..."

cd "$HOME/code/dotfiles"
bash setup.sh

echo ""

# ------------------------------------------------------------------
# 8. Ghostty terminal config
# ------------------------------------------------------------------
echo ">>> Setting up Ghostty config..."

mkdir -p "$HOME/.config/ghostty"
if [ ! -f "$HOME/.config/ghostty/config" ]; then
    cat > "$HOME/.config/ghostty/config" << 'GHOSTTY'
# Ghostty Configuration
theme = Dracula+
font-size = 24

# Word navigation: opt+arrow moves by word
keybind = alt+left=esc:b
keybind = alt+right=esc:f

# Word deletion: opt+backspace deletes last word
keybind = alt+backspace=backward_kill_word

# Paste image from clipboard: cmd+shift+v saves to file
keybind = cmd+shift+v=send_text:pi\r
GHOSTTY
    echo "  Created Ghostty config"
else
    echo "  Ghostty config already exists"
fi

echo ""

# ------------------------------------------------------------------
# 9. SSH keys
# ------------------------------------------------------------------
echo ">>> SSH key setup..."

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$HOME/.ssh/helrabelo@gmail.com" ]; then
    echo ""
    echo "  MANUAL STEP: Copy SSH keys from MacBook."
    echo "  On MacBook, run:"
    echo "    scp ~/.ssh/helrabelo@gmail.com ~/.ssh/helrabelo@gmail.com.pub helrabelo@<mini-ip>:~/.ssh/"
    echo ""
    echo "  Or use AirDrop to send the key files."
    echo ""
    echo "  Keys you'll likely need:"
    echo "    - helrabelo@gmail.com (GitHub personal)"
    echo "    - hel@planetary.co (Planetary — only if needed on Mini)"
    echo ""
fi

echo ""

# ------------------------------------------------------------------
# 10. MCP Servers (Serena)
# ------------------------------------------------------------------
echo ">>> Setting up MCP servers..."

if [ ! -d "$HOME/serena" ]; then
    echo "  Cloning Serena..."
    git clone https://github.com/oramasearch/serena.git "$HOME/serena"
fi

echo ""

# ------------------------------------------------------------------
# 11. macOS preferences (match MacBook)
# ------------------------------------------------------------------
echo ">>> Applying macOS preferences..."

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Dock: auto-hide, size 40
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 40

# Finder: show path bar, status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Key repeat speed (fast)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Trackpad: tap to click (if using Apple Trackpad)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Screenshots: save to ~/Desktop, disable shadow
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true

# Restart affected services
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

echo ""

# ------------------------------------------------------------------
# 12. Project setup
# ------------------------------------------------------------------
echo ">>> Setting up project directories..."

mkdir -p "$HOME/code/work/ayeeye"
mkdir -p "$HOME/code/work/planetary"
mkdir -p "$HOME/code/helsky-labs"
mkdir -p "$HOME/code/personal"
mkdir -p "$HOME/code/tooling"

echo ""

# ------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------
echo "=== Setup Complete ==="
echo ""
echo "MANUAL STEPS REMAINING:"
echo ""
echo "  1. APPS TO INSTALL MANUALLY:"
echo "     - Ghostty:        https://ghostty.org"
echo "     - VS Code/Cursor: https://code.visualstudio.com"
echo "     - Slack:           App Store"
echo "     - 1Password:       App Store"
echo "     - Rectangle Pro:   https://rectangleapp.com/pro"
echo "     - Logi Options+:   https://www.logitech.com/en-us/software/logi-options-plus.html"
echo "     - Obsidian:        https://obsidian.md"
echo "     - Alfred 5:        https://www.alfredapp.com"
echo ""
echo "  2. AUTHENTICATION:"
echo "     - claude auth login"
echo "     - gh auth login"
echo "     - npm login (if needed)"
echo "     - git clone your AyeEye repo into ~/code/work/ayeeye/"
echo ""
echo "  3. SSH KEYS:"
echo "     - Copy from MacBook via AirDrop or scp"
echo "     - Add to ssh-agent: ssh-add ~/.ssh/helrabelo@gmail.com"
echo ""
echo "  4. LOGITECH MX SETUP:"
echo "     - Open Logi Options+"
echo "     - Pair keyboard Channel 1 = Mac Mini"
echo "     - Pair mouse Channel 1 = Mac Mini"
echo "     - Enable Logitech Flow (if using both screens)"
echo ""
echo "  5. DISPLAY:"
echo "     - Connect Mac Mini to Dell 34\" via USB-C"
echo "     - System Settings > Displays > Arrange if using both screens"
echo ""
echo "  6. FOCUS MODE:"
echo "     - Create 'AyeEye' focus mode"
echo "     - System Settings > Focus > Share Across Devices = OFF"
echo ""
echo "  Restart your terminal and run: source ~/.zshrc"
echo ""
