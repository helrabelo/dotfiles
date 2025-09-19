#!/bin/bash

# Dotfiles Setup Script
# This script creates symlinks from home directory to dotfiles repo

DOTFILES_DIR="$HOME/Code/dotfiles"

echo "=== Setting up dotfiles ==="
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# Function to backup and symlink
link_file() {
    local src="$1"
    local dest="$2"

    # If destination exists and is not a symlink, back it up
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "  Backing up existing $dest to $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    # Remove existing symlink if it exists
    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    # Create symlink
    ln -s "$src" "$dest"
    echo "  ✓ Linked $dest -> $src"
}

# Shell configuration
echo "Setting up shell configuration..."
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/.zshrc-dev-optimizations" "$HOME/.zshrc-dev-optimizations"

# Git configuration
echo ""
echo "Setting up git configuration..."
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Claude configuration
echo ""
echo "Setting up Claude configuration..."
link_file "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/CLAUDE.md"
link_file "$DOTFILES_DIR/claude/.claude" "$HOME/.claude"

# Scripts
echo ""
echo "Setting up scripts..."
mkdir -p "$HOME/bin"
for script in "$DOTFILES_DIR/scripts"/*.sh; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        link_file "$script" "$HOME/bin/$script_name"
        chmod +x "$HOME/bin/$script_name"
    fi
done

# Add ~/bin to PATH if not already there
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
    echo "  ✓ Added ~/bin to PATH"
fi

echo ""
echo "=== Dotfiles setup complete! ==="
echo ""
echo "Next steps:"
echo "1. Review the backed up files (.backup extension)"
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Commit and push to your private GitHub repo"