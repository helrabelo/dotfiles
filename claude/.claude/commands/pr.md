# PR

Create a pull request from the current branch.

## Input

$ARGUMENTS

Optionally provide:
- Target base branch (defaults to `main` or `master`)
- Ticket ID to link (e.g., `DTF-123`)

---

## Phase 1: Gather Context

1. **Branch info**
   - Get current branch name with `git branch --show-current`
   - Determine base branch (`main` or `master`)
   - Check if branch is pushed to remote

2. **Diff analysis**
   - Run `git log {base}...HEAD --oneline` for commit history
   - Run `git diff {base}...HEAD --stat` for file change summary
   - Read the actual diff to understand the changes

3. **Extract ticket ID** (if not provided)
   - Parse from branch name (e.g., `feature/DTF-123__description`)
   - If none found, proceed without ticket link

---

## Phase 2: Generate PR Content

### Title
- Format: `{TICKET-ID}: {Brief description}` or just `{Brief description}` if no ticket
- Under 70 characters
- Imperative mood ("Add menu filtering" not "Added menu filtering")

### Body

Use the Planetary PR template:

```markdown
## Ticket
[{TICKET-ID}](https://linear.app/planetary/issue/{TICKET-ID})
<!-- Or "No ticket" -->

## Summary
**Problem:** {What issue or need does this PR address?}
**Solution:** {What was changed and why?}
**How it works:** {Brief explanation of approach}

## Testing / QA Steps
1. {Step-by-step verification instructions}

## Acceptance Criteria
- [ ] {What defines "done"}
```

---

## Phase 3: Deliverables

1. **Show the PR content** for review before creating

2. **Ask user to confirm** before running `gh pr create`

3. **Provide the command** ready to run:
   ```
   gh pr create --title "{title}" --body "{body}" --base {base}
   ```

4. **Slack update** (optional, if user wants):
   ```
   PR ready for review: {title}
   - {1-2 sentence summary}
   - Link: {PR URL}
   ```

---

## Reminders

- Do NOT push to remote without asking -- check if branch is pushed first
- Do NOT create the PR without showing the content first
- Do NOT add co-author tags or Claude references
- Keep the title concise -- details go in the body
