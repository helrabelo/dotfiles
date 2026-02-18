# Deploy Check

Pre-deploy sanity check for the current project.

## Input

$ARGUMENTS

Optionally specify project path. Defaults to current working directory.

---

## Phase 1: Environment Check

1. **Verify project state**
   - Run `git status` -- check for uncommitted changes
   - Identify current branch
   - Check if branch is up to date with remote

2. **Identify project type**
   - Check for `next.config.*` (Next.js)
   - Check for `vite.config.*` (Vite)
   - Check for `Package.swift` (Swift)
   - Determine available scripts from `package.json`

---

## Phase 2: Code Quality Checks

1. **Build verification**
   - Run the project's build command (`npm run build`, `next build`, etc.)
   - Report any build errors with file locations

2. **Type checking** (if TypeScript)
   - Run `npx tsc --noEmit`
   - Report type errors

3. **Lint check** (if configured)
   - Run `npm run lint` or equivalent
   - Report lint warnings and errors

4. **Test suite** (if configured)
   - Run `npm test` or equivalent
   - Report test results summary

---

## Phase 3: Debug Code Scan

Search the staged/changed files for:

- [ ] `console.log` statements (not in test files)
- [ ] `debugger` statements
- [ ] `TODO` or `FIXME` comments in new code
- [ ] Hardcoded `localhost` URLs
- [ ] `.only` in test files (test.only, describe.only)
- [ ] Commented-out code blocks

---

## Phase 4: Summary

```markdown
## Deploy Check: {project name}

**Branch:** {branch}
**Uncommitted changes:** Yes/No
**Up to date with remote:** Yes/No

### Results

| Check | Status | Details |
|-------|--------|---------|
| Build | PASS/FAIL | {details} |
| Types | PASS/FAIL/SKIP | {details} |
| Lint | PASS/FAIL/SKIP | {details} |
| Tests | PASS/FAIL/SKIP | {details} |
| Debug code | CLEAN/FOUND | {details} |

### Verdict: GO / NO-GO

{If NO-GO, list what needs to be fixed}
```

---

## Reminders

- Do NOT push to remote -- just report the results
- Do NOT fix issues automatically -- report them for the user to decide
- If build fails, show the relevant error output
- Be explicit about what was checked vs skipped
