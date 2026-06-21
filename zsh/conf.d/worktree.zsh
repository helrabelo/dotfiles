# wt: git worktree helper. Worktrees live in <main-repo>/.worktrees/<slug> so
# they stay under ~/code/<ctx>/ and inherit the per-context git identity via the
# includeIf rules. .worktrees/ is globally gitignored (see git/.gitignore_global).
#
#   wt <branch>    create-or-cd a worktree for <branch> (new branch if it does
#                  not exist)
#   wt ls          list worktrees
#   wt rm <slug>   remove a worktree (via `git worktree remove`, never rm -rf)

# Path of the MAIN worktree (where .worktrees/ is anchored), from anywhere in
# the repo, including from inside another worktree.
_wt_main_root() {
  git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print $2; exit}'
}

wt() {
  local cmd="${1:-}"
  case "$cmd" in
    ls|list)
      git worktree list
      ;;
    rm|remove)
      local slug="${2:-}"
      [[ -n "$slug" ]] || { echo "usage: wt rm <slug>"; return 1; }
      local root; root="$(_wt_main_root)" || { echo "wt: not in a git repo"; return 1; }
      [[ -n "$root" ]] || { echo "wt: not in a git repo"; return 1; }
      git worktree remove "$root/.worktrees/$slug"
      ;;
    ""|-h|--help)
      echo "usage: wt <branch> | wt ls | wt rm <slug>"
      [[ -z "$cmd" ]] && return 1 || return 0
      ;;
    *)
      local branch="$cmd"
      local slug="${branch//\//-}"      # feat/x -> feat-x for the directory
      local root; root="$(_wt_main_root)" || { echo "wt: not in a git repo"; return 1; }
      [[ -n "$root" ]] || { echo "wt: not in a git repo"; return 1; }
      local wtdir="$root/.worktrees/$slug"
      if [[ -d "$wtdir" ]]; then
        cd "$wtdir"
      elif git show-ref --verify --quiet "refs/heads/$branch"; then
        git worktree add "$wtdir" "$branch" && cd "$wtdir"
      else
        git worktree add -b "$branch" "$wtdir" && cd "$wtdir"
      fi
      ;;
  esac
}
