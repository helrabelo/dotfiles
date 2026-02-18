# Code Review

Perform a thorough code review for a PR or branch.

## Input Required

$ARGUMENTS

Provide one of:
- PR number (e.g., `#123`)
- PR URL (e.g., `https://github.com/org/repo/pull/123`)
- Branch name to compare against main
- File paths to review specific files

---

## Phase 1: Context Gathering

1. **Identify what to review**
   - If PR number/URL: fetch PR details with `gh pr view`
   - If branch: compare against main/master
   - If files: focus review on specified files

2. **Understand the ticket/purpose**
   - Read linked ticket if available
   - Understand the intended behavior change
   - Note acceptance criteria

3. **Get the diff**
   - `gh pr diff` for PRs
   - `git diff main...{branch}` for branches

---

## Phase 2: Code Analysis

Review each changed file for:

### Correctness
- [ ] Does the code do what it's supposed to do?
- [ ] Are edge cases handled?
- [ ] Is error handling appropriate?
- [ ] Are there any logic bugs?

### Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation present where needed
- [ ] No SQL injection, XSS, or command injection vulnerabilities
- [ ] Proper authentication/authorization checks
- [ ] Sensitive data handled appropriately

### Performance
- [ ] No unnecessary re-renders (React)
- [ ] No N+1 queries or expensive operations in loops
- [ ] Appropriate use of caching/memoization
- [ ] No memory leaks (event listeners, subscriptions cleaned up)

### Code Quality
- [ ] Follows project conventions and patterns
- [ ] DRY - no unnecessary duplication
- [ ] Single responsibility - functions/components do one thing
- [ ] Clear naming for variables, functions, components
- [ ] Appropriate typing (TypeScript)

### Maintainability
- [ ] Code is readable and self-documenting
- [ ] Complex logic has comments explaining "why"
- [ ] No dead code or commented-out blocks
- [ ] Tests added/updated for new functionality

### Project-Specific (Planetary)
- [ ] Sanity schema changes have corresponding type updates
- [ ] SCSS follows project patterns (mixins, variables)
- [ ] i18n strings added for user-facing text
- [ ] Responsive design considerations

---

## Phase 3: Generate Review

### Summary Format

```markdown
## Review Summary

**PR:** {title/number}
**Scope:** {brief description of what changed}
**Risk Level:** Low / Medium / High

### Overview
{1-2 paragraph summary of the changes and overall assessment}

### Approval Status
- [ ] Approved - Ready to merge
- [ ] Approved with suggestions - Optional improvements noted
- [ ] Changes requested - Must address before merge
- [ ] Needs discussion - Questions to clarify before deciding

---

## Findings

### Critical (Must Fix)
{Issues that block approval}

### Important (Should Fix)
{Issues that should be addressed but aren't blocking}

### Suggestions (Nice to Have)
{Optional improvements for code quality}

### Questions
{Clarifications needed from the author}

---

## File-by-File Notes

### `path/to/file.ts`
- Line X: {comment}
- Line Y: {comment}

---

## Testing Verification

- [ ] Tested locally following QA steps
- [ ] Verified expected behavior
- [ ] Checked for regressions

**Test Environment:** {Local / Staging}
**Test Notes:** {Any observations during testing}
```

---

## Phase 4: Deliverables

Provide the user with:

1. **Review Summary** - Using format above

2. **GitHub Review Comment** - Condensed version suitable for PR comment:
   ```markdown
   ## Review

   {Approval status emoji} **{Status}**

   ### Summary
   {Brief overview}

   ### Findings
   {Key items only - details in inline comments}

   ### Suggestions
   {Optional improvements}
   ```

3. **Inline Comments** - Specific line-by-line feedback for the author (list format for user to add manually)

---

## Review Standards

### Approval Criteria
- **Approve**: No critical issues, code is production-ready
- **Approve with suggestions**: Minor improvements possible but not required
- **Request changes**: Critical issues or bugs that must be fixed
- **Needs discussion**: Architectural concerns or scope questions

### Communication Tone
- Be constructive, not critical
- Explain the "why" behind feedback
- Offer solutions, not just problems
- Acknowledge good work when you see it
- Use "consider" or "suggestion:" for optional feedback
- Use "important:" or "blocking:" for required changes

---

## Reminders

- Review the code, not the person
- Focus on significant issues over style nitpicks
- If unsure about something, ask rather than assume
- Consider the context and constraints the author worked within
