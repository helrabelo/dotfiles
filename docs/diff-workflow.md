# Staying in touch with diffs

As more code is AI-generated, the risk is losing your feel for what actually
changed. The fix is two layers: make diffs pleasant to read, and keep a gate
you cannot skip.

## Render: git-delta

`delta` is the git pager (set in `git/.gitconfig`). Every `git diff`,
`git show`, and `git log -p` is syntax-highlighted with a line-number gutter,
and `git add -p` hunks are delta-colored too (via `interactive.diffFilter`).

- `n` / `N` jump between files inside the pager.
- Side-by-side is off by default. Turn it on per command:
  `git -c delta.side-by-side=true diff`.
- Moved lines are highlighted (`diff.colorMoved`), so an AI reformat reads
  differently from a real logic change.
- Theme is Dracula, to match the Ghostty theme.

## Review: lazygit

`lg` opens lazygit in the current repo: stage and review hunk by hunk, see
every change before it commits. `gap` (`git add -p`) does the same from the
shell with no extra tool.

(`lg` is lazygit; the `git lg` alias is the separate pretty-log. Different
namespaces, no conflict.)

## The gate: branch, review the diff, merge

The real defense against losing touch is structural, not cosmetic. The pattern
this repo already uses for its own phases:

1. AI writes on a branch, never straight to main.
2. You review the full diff before it lands: `gh pr diff <n>`, the PR on
   GitHub, or `git diff main...HEAD` locally.
3. You merge. The merge is always yours.

A renderer makes the looking nicer. The gate makes you actually look. Keep
both.

## In a Claude Code session

- Ask for the full diff before any commit, and walk it.
- `/code-review` for a structured pass; `/code-review ultra` (ultrareview) for
  a deeper multi-agent review of the branch.
