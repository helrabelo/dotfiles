# Login shell profile.
#
# Dropped vs the old .zprofile: stale Python.framework 3.12/3.10 PATH prepends
# and the nvm loader (mise now owns node).

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# mise shims for non-interactive shells (interactive shells get the full
# `mise activate` in conf.d/tools.zsh). Replaces nvm's old non-interactive role.
[ -d "$HOME/.local/share/mise/shims" ] && export PATH="$HOME/.local/share/mise/shims:$PATH"
