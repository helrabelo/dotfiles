# Do Ticket

Work on a Linear ticket from planning through PR creation.

## Input Required

$ARGUMENTS

Provide ticket ID (e.g., `DTF-123`, `WELL-456`) or "no ticket" for ad-hoc work.

---

## Phase 1: Context Gathering

1. **Parse ticket reference** from input
   - Extract ticket ID pattern: `{PROJECT}-{NUMBER}` (e.g., DTF-123, WELL-456, BUR-789)
   - If "no ticket" specified, proceed without ticket linking

2. **Understand the request**
   - Ask clarifying questions if the task is ambiguous
   - Identify affected areas of the codebase
   - Determine scope and complexity

---

## Phase 2: Planning

1. **Create implementation plan**
   - List files that will be modified/created
   - Identify potential risks or blockers
   - Note any dependencies or prerequisites

2. **Get user approval** before proceeding with significant changes

---

## Phase 3: Implementation

1. **Create feature branch** (if not already on one)
   - Format: `feature/{TICKET-ID}__{brief-description}` (e.g., `feature/DTF-123__add-menu-filtering`)
   - For no-ticket work: `feature/{brief-description}`

2. **Execute the plan**
   - Make changes incrementally
   - Keep commits focused and atomic

3. **Validate changes**
   - Run build: verify no build errors
   - Run tests: verify tests pass (if applicable)
   - Manual verification if needed

---

## Phase 4: Commit & PR Preparation

1. **Commit changes**
   - Use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`
   - Reference ticket in commit message when applicable

2. **Prepare PR content** following the template at `~/code/work/planetary/.github/.github/PULL_REQUEST_TEMPLATE.md`:

   ```markdown
   ## Ticket
   [{TICKET-ID}](https://linear.app/planetary/issue/{TICKET-ID})
   <!-- Use "No ticket" if none -->

   ## Summary
   **Problem:** [What issue or need does this PR address?]
   **Solution:** [What was changed and why?]
   **How it works:** [Brief explanation of approach]

   ## Testing / QA Steps
   1. [Step-by-step verification instructions]

   ## Acceptance Criteria
   - [ ] [What defines "done"]
   ```

---

## Phase 5: Deliverables

Provide the user with:

1. **PR Title** - Format: `{ticket-id}: Brief description` (e.g., `DTF-123: Add menu filtering`)

2. **PR Description** - Complete template from Phase 4

3. **Slack Update** - Short message for team channel:
   ```
   PR ready for review: [PR Title]
   - [1-2 sentence summary of what changed]
   - Link: [will be added after PR creation]
   ```

4. **Linear Update** - Comment for the ticket:
   ```
   PR submitted: [PR Title]
   Changes: [Brief summary]
   Status: Ready for review
   ```

---

## Reminders

- Do NOT push to remote - ask user to push
- Do NOT run destructive git commands without explicit permission
- Do NOT add co-author tags or Claude references
- If build/tests fail, report the issue and ask how to proceed
