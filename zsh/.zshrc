# zsh interactive shell config. Modular: see conf.d/.
# Phase 3 of the dotfiles rebuild, replacing the oh-my-zsh + spaceship monolith.
#
# nvm/rbenv/oh-my-zsh stay installed on disk as fallback; their shell init is
# gone here (mise owns runtimes, starship owns the prompt).

# Real directory of this file, following the ~/.zshrc symlink into the repo.
ZSH_DOTDIR="${${(%):-%x}:A:h}"

# Source modules in dependency order (env before path; tools before keybindings).
for _mod in env path tools functions worktree aliases keybindings context; do
  [ -r "$ZSH_DOTDIR/conf.d/$_mod.zsh" ] && source "$ZSH_DOTDIR/conf.d/$_mod.zsh"
done
unset _mod
