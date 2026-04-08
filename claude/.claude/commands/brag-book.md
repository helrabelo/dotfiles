# Brag Book

Generate a brag book entry from GitHub activity.

## Input

$ARGUMENTS

Options:
- No arguments: today's activity
- A date like `2026-02-20`: specific date
- `week`: all days in the current week
- `month`: all days in the current month

---

## Phase 1: Fetch Activity

Run the brag-book script to fetch GitHub activity and generate the markdown file.

```bash
# Determine the command based on arguments
# Default (no args or specific date):
node ~/helsky-vault/06\ System/Scripts/brag-book.js --date <DATE>

# For "week" or "month":
node ~/helsky-vault/06\ System/Scripts/brag-book.js --range <week|month>
```

If `$ARGUMENTS` is empty, use today's date. If it contains a date (YYYY-MM-DD format), pass it with `--date`. If it contains "week" or "month", pass it with `--range`.

---

## Phase 2: Enhance Summary

After the script runs, read the generated markdown file(s).

For each generated file:
1. Read the file content
2. Based on the commits, PRs, reviews, and issues — write a **brief narrative summary** (2-3 sentences) that describes what the day's work adds up to in plain language. Think of it as how you'd describe the day to a manager.
3. Insert the narrative right after the `# Date` heading and before `## Summary`, like:

```markdown
# Monday, February 23, 2026

> Focused on authentication improvements across the DTF project, with a side of dependency updates for helrabelo.dev. Reviewed two PRs for the team and shipped a bug fix to production.

## Summary
```

4. Write the enhanced file back to the same path.

---

## Phase 3: Confirm

Tell the user:
- Which file(s) were written and their paths
- A quick summary of the day's activity
- If running a range, show a brief overview of the most active days

---

## Reminders

- The script handles all GitHub API calls and multi-account switching
- The script is idempotent — re-running for the same date is safe
- If the script fails, check that `gh` CLI is authenticated: `gh auth status`
- Files go to `~/helsky-vault/BragBook/YYYY/Month/Week N/Weekday.md`
