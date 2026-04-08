# Standup

Automated standup generator that correlates GitHub activity with Linear tickets and creates a Slack draft in #standup.

## Input

$ARGUMENTS

Optionally specify:
- Time range override (default: auto-detect last active business day)
- Specific project paths to scan
- `--dry-run` to generate the standup without posting to Slack

---

## Phase 0: Pre-Checks

### Check if today is a workday

Run `date +%u` to get the day of week (1=Monday, 7=Sunday).

- If the result is 6 (Saturday) or 7 (Sunday), **stop immediately** and say: "It's the weekend. No standup needed. Go touch grass."
- If 1-5, continue.

### Check if user is OOO

Check the Planetary **Vacations** calendar (`vacations@planetary.co`) for an all-day event named "Hel OOO" that covers today:

```
gcal_list_events(
  calendarId: "vacations@planetary.co",
  timeMin: "<today>T00:00:00",
  timeMax: "<today>T23:59:59",
  q: "Hel OOO"
)
```

- If a matching all-day event is found that spans today, **stop immediately** and say: "You're OOO today. No standup posted. Enjoy your day off."
- If no match, continue.

---

## Phase 1: Determine Last Active Business Day

The goal: find the correct `--since` date for git log, skipping weekends and holidays.

### Step 1: Calculate candidate date

- If today is **Monday** → candidate is last **Friday**
- If today is **Tuesday-Friday** → candidate is **yesterday**

### Step 2: Check for holidays in the lookback window

Use `gcal_list_events` to check the candidate date for company holidays or OOO:

```
gcal_list_events(
  calendarId: "primary",
  timeMin: "<candidate_date>T00:00:00",
  timeMax: "<candidate_date>T23:59:59",
  q: "holiday"
)
```

Also check for "Company Holiday", "Office Closed", "Feriado" (Portuguese).

If the candidate date was a holiday, step back one more business day and check again. Repeat until a valid business day is found. Don't go back more than 5 business days.

### Step 3: Set the lookback date

Store the final date as `SINCE_DATE` for use in git commands.

---

## Phase 2: GitHub Activity

Scan the following project directories for commits since `SINCE_DATE`:

### Planetary Projects
- `/Users/helrabelo/code/work/planetary/din-tai-fung-website`
- `/Users/helrabelo/code/work/planetary/the-well`
- Any other projects with recent activity in `/Users/helrabelo/code/work/planetary/`

### Helsky Labs
- `/Users/helrabelo/code/helsky-labs/` and subdirectories

### Personal
- `/Users/helrabelo/code/personal/helrabelo.dev`

For each project with a `.git` directory, run:
```bash
git log --since="SINCE_DATE" --author="helrabelo" --oneline --all
```

Also check:
- Current branch and any work-in-progress (uncommitted changes via `git status --short`)
- Any open PRs via `gh pr list --author @me --state open`

**Extract ticket IDs** from commit messages and branch names. Look for patterns like `DTF-123`, `WEL-45`, `PLA-100`, `BUR-67`, `MIL2-89` (the Planetary Linear team codes).

---

## Phase 3: Linear Tickets

Use the Linear MCP to fetch actively assigned tickets:

```
list_issues(
  assignee: "me"
)
```

From the results, **keep only tickets whose state/status is NOT any of**:
- Backlog
- Todo / To Do
- Done
- Completed
- Cancelled / Canceled
- Pending Estimate

Everything else (In Progress, In Review, Blocked, QA, Staging, etc.) represents actively worked-on tickets.

Group the remaining tickets by team/project (DTF, WEL, PLA, BUR, MIL2).

---

## Phase 4: Correlate GitHub + Linear

Match GitHub activity to Linear tickets:

1. For each **ticket ID found in commits/branches** (Phase 2), find the matching Linear ticket (Phase 3) and group the commits under that ticket.
2. For each **Linear ticket with no matching commits**, list it as "assigned but no recent git activity" — it's still actively assigned work.
3. For any **commits with no ticket ID**, list them separately as untracked work.

This correlation gives the full picture:
- Tickets with recent commits → "what I worked on"
- Tickets assigned but no commits → "what's on my plate"
- Commits with no ticket → "other work"

---

## Phase 5: Generate Standup Message

Format the standup as a Slack message using this structure:

```
*Today*

*Client Name* — [TICKET-1](https://linear.app/planetary/issue/TICKET-1), [TICKET-2](https://linear.app/planetary/issue/TICKET-2)
*Client Name* — [TICKET-3](https://linear.app/planetary/issue/TICKET-3)
```

Rules for generating:
- Start with `*Today*` in bold. No date header, no "Yesterday" section, no "Standup - {date}" title.
- Group tickets by client/team name. The client name should be bold (`*Client Name*`).
- After the client name, list all active ticket IDs as embedded links separated by commas. Use the format `[DTF-609](https://linear.app/planetary/issue/DTF-609)`.
- Include tickets from both sources: tickets with recent git commits AND actively assigned Linear tickets (from Phase 3/4).
- One line per client. If a client has no active tickets, skip it.
- Keep it minimal. No descriptions, no blockers section, no commentary. Just the client name and linked tickets.

---

## Phase 6: Post to Slack

### Step 1: Find the #standup channel

Use `slack_search_channels` to find the channel:
```
slack_search_channels(query: "standup")
```

### Step 2: Create the draft

Use `slack_send_message_draft` to create a draft in the #standup channel:
```
slack_send_message_draft(
  channel_id: "<standup_channel_id>",
  message: "<formatted standup message>"
)
```

**Important**: Do NOT send the message directly. Always create a **draft** so the user can review before posting.

### Step 3: Confirm

Tell the user:
- The draft has been created in #standup
- Provide the channel link returned by the tool
- Show the full standup text so they can see what was drafted
- Remind them to review and send from Slack

---

## Reminders

- Only scan directories that exist
- If no activity found for a project, skip it silently
- Keep it concise — standups should be quick reads
- Use commit messages as-is when they're descriptive enough
- If `--dry-run` is passed, show the standup but do NOT post to Slack
- If `slack_send_message_draft` fails with "draft_already_exists", tell the user they have an existing draft in #standup that needs to be sent or deleted first
- Planetary-only work should be in the standup. Helsky Labs / personal project work can be mentioned briefly if relevant but is not the focus.
