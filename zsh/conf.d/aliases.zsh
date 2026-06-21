# Aliases.

# Claude Code (Phase 4 will scope this per context)
alias c="claude --dangerously-skip-permissions --verbose"

# Helsky vault logging aliases
[ -r "$HOME/.helsky-vault-aliases" ] && source "$HOME/.helsky-vault-aliases"

# Generic dev utilities (ported from the retired .zshrc-dev-optimizations;
# the stale ~/Code/work/* navigation aliases were dropped)
alias clean-npm="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +"
alias clean-ds="find . -name '.DS_Store' -type f -delete"
alias git-status-all="find . -name .git -type d -prune -exec sh -c 'cd \"\${0%/.git}\" && echo \"===== \$(basename \"\$(pwd)\") =====\" && git status -s' {} \;"
