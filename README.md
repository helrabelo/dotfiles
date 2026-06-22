# Helena's Dotfiles

Personal dotfiles and development environment configuration.

## Structure

```
dotfiles/
├── zsh/                 # Shell configuration
│   ├── .zshrc          # Main zsh config
│   ├── .zprofile       # Profile settings
│   └── .zshrc-dev-*    # Development optimizations
├── git/                 # Git configuration
│   ├── .gitconfig      # Git settings
│   ├── .gitconfig-*    # Per-context identities (currents, planetary, burlington)
│   └── .gitignore_global
├── ssh/                 # SSH client config (per-context GitHub host aliases)
├── 1password/           # 1Password SSH agent config (agent.toml)
├── claude/              # Claude AI workflow
│   ├── CLAUDE.md       # Root instructions
│   └── .claude/        # Claude settings
├── scripts/             # Utility scripts
│   ├── cleanup-*.sh    # Cleanup utilities
│   └── organize-*.sh   # Organization scripts
└── setup.sh            # Installation script
```

## Installation

### Quick Setup

```bash
# Clone the repo
git clone https://github.com/helrabelo/dotfiles.git ~/code/dotfiles

# Run setup
cd ~/code/dotfiles
chmod +x setup.sh
./setup.sh
```

### Manual Setup

If you prefer to manually link specific files:

```bash
# Example: Link zshrc
ln -s ~/code/dotfiles/zsh/.zshrc ~/.zshrc
```

## What's Included

### Shell (Zsh)
- zinit plugin manager (fast-syntax-highlighting, autosuggestions, completions)
- VS Code-style keybindings (Option+arrow word nav, Ctrl+A/E, kill-line, history search)
- `pi` clipboard-image paste helper
- `c` alias for Claude Code
- zoxide (smarter `cd`) + direnv hooks
- Helsky vault logging aliases (via `~/.helsky-vault-aliases`)

### Git
- Global gitignore for common files
- Useful aliases and configurations
- Commit signing setup
- `delta`-rendered diffs and a review workflow (see `docs/diff-workflow.md`)

### Claude
- Root-level CLAUDE.md for AI pair programming
- Project structure documentation
- Workflow instructions

### Scripts
- `cleanup-node-modules.sh` - Remove unnecessary node_modules
- `organize-projects.sh` - Reorganize dev projects
- `weekly-cleanup.sh` - Regular maintenance
- `organize-home.sh` - Home directory organization

## Security Notes

**Never commit:**
- `.git-credentials`
- `.npmrc` (contains auth tokens)
- `.wakatime.cfg` (API keys)
- `.netrc` (passwords)
- Any `.env` files

## Customization

After installation, you can customize:
1. Edit files in `~/code/dotfiles/`
2. Changes will reflect immediately (they're symlinked)
3. Commit and push your changes

## New Machine Setup

1. Install Homebrew
2. Clone this repo
3. Run `./setup.sh`
4. Install development tools as needed