# Standup

Generate standup notes from recent git activity.

## Input

$ARGUMENTS

Optionally specify:
- Time range (default: since yesterday)
- Specific project paths to scan

---

## Phase 1: Scan Activity

Check the following project directories for recent commits:

### Planetary Projects
- `/Users/helrabelo/code/work/planetary/din-tai-fung-website`
- `/Users/helrabelo/code/work/planetary/the-well`
- Any other projects with recent activity in `/Users/helrabelo/code/work/planetary/`

### Helsky Labs
- `/Users/helrabelo/code/helsky-labs/` and subdirectories

### Personal
- `/Users/helrabelo/code/personal/helrabelo.dev`

For each project with a `.git` directory, run:
```
git log --since="yesterday" --author="helrabelo" --oneline
```

Also check:
- Current branch and any work-in-progress (uncommitted changes via `git status`)
- Any open PRs via `gh pr list --author @me --state open`

---

## Phase 2: Categorize

Group findings into:

1. **Completed** -- Merged PRs, completed features
2. **In Progress** -- Current branches with recent commits
3. **Blockers** -- Failed builds, stale PRs awaiting review, dependency issues

---

## Phase 3: Generate Standup

```markdown
## Standup - {date}

### Yesterday
- {Project}: {What was done}
- {Project}: {What was done}

### Today
- {Project}: {What's planned based on in-progress work}

### Blockers
- {Any blockers found, or "None"}
```

Also provide a **short version** for Slack:
```
Yesterday: {1-2 lines}
Today: {1-2 lines}
Blockers: {None or brief description}
```

---

## Reminders

- Only scan directories that exist
- If no activity found for a project, skip it
- Keep it concise -- standups should be quick
- Use commit messages as-is when they're descriptive enough
