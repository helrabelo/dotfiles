# Do Ticket

Work on a Linear ticket from triage check through PR creation, per the Planetary Handbook.

## Input

$ARGUMENTS

Ticket ID (e.g., `DTF-123`, `MIL2-45`, `WEL-89`, `BUR-789`) or "no ticket" for ad-hoc work.

---

## Pre-flight: working directory check

Run `pwd`. If the current working directory is **not** under `/Users/helrabelo/code/planetary/`, **STOP** and tell Hel:

> "Current working directory is `<CWD>`. The `/do-ticket` flow needs to be started from inside the relevant client repo (e.g., `~/code/planetary/din-tai-fung-website/` for DTF, `~/code/planetary/177milkstreet/` for MIL2). Vault docs load via absolute paths and would still work, but phases 6-8 (branch / build / commit / PR) require the client repo as CWD. Please restart Claude from the right directory."

Do not proceed past this check from outside the planetary code workspace. Project-level `CLAUDE.md` files only auto-load at session start based on launch directory, so a mid-session `cd` does not recover the lost context.

---

## Phase 0: Load handbook context

Read these in order. They are the canonical source for how work flows through Planetary.

- `~/helsky-vault/contexts/planetary/HANDBOOK.md`
- `~/helsky-vault/contexts/planetary/DOD.md`
- `~/helsky-vault/contexts/planetary/PEOPLE.md`
- `~/helsky-vault/contexts/planetary/STATE.md`
- `~/helsky-vault/contexts/planetary/<client>/STATE.md`
- `~/helsky-vault/contexts/planetary/<client>/MAP.md`

Resolve `<client>` from the ticket prefix:

| Prefix | Client folder |
|---|---|
| DTF | din-tai-fung |
| MIL2 | milk-street |
| BUR, BVP | burlington |
| WEL | the-well |
| PLA | (Planetary internal, no per-client folder) |

---

## Phase 1: Triage gate

Read the ticket on Linear.
**Verify it is in the team's Backlog, not Triage.** If Triage: STOP and surface to Hel. Engineers do not self-accept from Triage. If a ticket is in Triage, the Director of Ops (Cynthia) has not reviewed it yet.

---

## Phase 2: Acceptance criteria confirmation (2-business-day window)

Read the acceptance criteria on the ticket.

- If clear and accurate: confirm explicitly with a Linear comment ("Acceptance criteria confirmed.").
- If wrong, vague, or technically unfeasible: post a **dispute comment on the ticket**. Do not relay disputes via Slack. Wait for Producer (Cynthia) sign-off on revised criteria before status moves to In Progress.

The 2-business-day window starts at assignment. Confirmation must happen before the next cycle starts, whichever is sooner.

---

## Phase 3: Estimate

Provide a story-point estimate using the handbook scale:

| Points | Time | Use for |
|---|---|---|
| 1 | Under an hour | Self-contained, no unknowns |
| 2 | Quarter day | Straightforward, minimal dependencies |
| 4 | Half a day | Moderate complexity, path is clear |
| 8 | One day | Meaningful complexity or cross-area dependencies |
| 16 | Two to three days | Big scope, confirm well-understood first |
| 32 | Most of a week | Decompose. Do not build a 32. |

Lead-reviewed before cycle entry. Engineering Lead is per-project (see `<client>/MAP.md`).

---

## Phase 4: Due date

Confirm the due date = the date the ticket reaches **Client Review**. Not when work starts. Not when QA finishes.
If the estimate-to-deadline math doesn't work, raise it on the ticket and renegotiate with the Producer.

---

## Phase 5: Discipline check

Confirm the ticket is single-discipline (engineering).
If cross-discipline: flag the missing twin design ticket to the Producer. One ticket cannot span eng + design per handbook.

---

## Phase 6: Branch + plan

Branch naming: `{type}/{ticket-id-lowercase}-{short-slug}`.

| Work type | Branch prefix | Commit prefix |
|---|---|---|
| Feature | `feature/` | `feat(...)` |
| Bug fix | `fix/` | `fix(...)` |
| Tech debt / chore | `chore/` | `chore(...)` |
| Refactor | `refactor/` | `refactor(...)` |
| Docs | `docs/` | `docs(...)` |

Examples:
- `feature/dtf-610-location-preview-component`
- `fix/mil2-379-magazine-heading-link`
- `chore/wel-89-update-deps`

For no-ticket work: `{type}/short-slug` (no ticket ID).

Draft an implementation plan: files affected, risks, dependencies. Get Hel's approval before significant changes.

---

## Phase 7: Implement

- Atomic commits using the workspace convention `{type}({TICKET-ID}): lowercase description` (see `~/code/planetary/CLAUDE.md`).
- Run build validation before every commit. Do not commit with type errors or build failures.
- **Mid-build scope changes:** Producer must comment on the ticket. If due-date impact, both Producer and lead sign off before continuing. Material changes = new linked ticket. See `HANDBOOK.md` "Scope Changes Mid-Build".

---

## Phase 8: PR + DoD pipeline

- Use the workspace PR template at `~/code/planetary/.github/.github/PULL_REQUEST_TEMPLATE.md` (mirrored in `~/code/planetary/CLAUDE.md`).
- PR title: `{ticket-id}: lowercase description` (e.g., `DTF-123: add menu filtering`).
- After PR creation, the ticket enters the DoD pipeline:
  - **Client engineering:** Code Review (peer eng) → QA Review (eng lead) → Client Review (Producer) → Done.
  - **Bug / tech debt / infra:** Code Review → QA Review → Done.
- See `~/helsky-vault/contexts/planetary/DOD.md` for the copy-pasteable per-pipeline checklist.

---

## Phase 9: Stage transition notes

Leave a brief comment on the ticket when moving between stages (per handbook ticket hygiene):
"Ready for QA, tested on Chrome and Safari" is sufficient. Silence is not.

---

## Phase 10: Vault update (end of session)

Before closing the session:

1. Update `~/helsky-vault/contexts/planetary/<client>/STATE.md`:
   - Active issues table (status, priority, points, branch).
   - Recent decisions (with absolute dates).
   - Open blockers.
   - Next steps.
2. Append a dated entry to `~/helsky-vault/contexts/planetary/<client>/ACTIVITY_LOG.md`. Use absolute `YYYY-MM-DD`.
3. Commit in the vault. Push only if the other machine needs the update.

---

## Reminders

- Do NOT push to remote. Ask Hel to push.
- Do NOT run destructive git commands without explicit permission.
- Do NOT add co-author tags or Claude references to commits or PRs.
- Do NOT merge PRs. Merging is manual, team-side.
- Build / test failures: report and ask. Do not auto-revert.
- One authorization = one execution. Never wrap a non-idempotent action in a retry loop.
