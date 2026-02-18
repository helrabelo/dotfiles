# Audit

Quick project health check for the current codebase.

## Input

$ARGUMENTS

Optionally specify:
- Specific checks to run (e.g., `deps`, `security`, `bundle`, `types`)
- Project path (defaults to current working directory)

---

## Phase 1: Project Identification

1. **Detect project type** from config files
   - `package.json` -- Node.js/JS project
   - `Package.swift` -- Swift project
   - `next.config.*` -- Next.js project
   - `tsconfig.json` -- TypeScript project

2. **Read project configuration** to understand available tools

---

## Phase 2: Dependency Health

1. **Outdated packages**
   - Run `npm outdated` (or equivalent)
   - Categorize: patch updates, minor updates, major updates
   - Flag any with known breaking changes

2. **Security vulnerabilities**
   - Run `npm audit`
   - Summarize: critical, high, moderate, low
   - Note which are direct vs transitive dependencies

3. **Unused dependencies** (if possible)
   - Cross-reference `package.json` dependencies with actual imports
   - Flag potentially unused packages

---

## Phase 3: Code Health

1. **TypeScript strictness** (if TS project)
   - Check `tsconfig.json` for strict mode settings
   - Run `npx tsc --noEmit` and count errors
   - Note any `@ts-ignore` or `any` type usage in changed files

2. **Bundle size** (if web project)
   - Check if bundle analysis is configured
   - Run `npm run build` and report output sizes
   - Flag any obviously large dependencies

3. **Code patterns scan**
   - Search for `console.log` outside test files
   - Search for `// TODO` and `// FIXME` comments
   - Search for `eslint-disable` comments
   - Count files with `any` type assertions

---

## Phase 4: Report

```markdown
## Project Audit: {project name}

**Date:** {date}
**Type:** {Next.js / React / Swift / etc.}
**Node:** {version} | **npm:** {version}

---

### Dependency Health

| Category | Count | Action Needed |
|----------|-------|---------------|
| Critical vulnerabilities | {n} | {Yes/No} |
| High vulnerabilities | {n} | {Yes/No} |
| Major updates available | {n} | Review |
| Minor updates available | {n} | Safe to update |
| Patch updates available | {n} | Safe to update |
| Potentially unused | {n} | Verify & remove |

### Code Health

| Metric | Value | Status |
|--------|-------|--------|
| TypeScript strict mode | On/Off | {OK/Warning} |
| Type errors | {n} | {OK/Warning} |
| `any` type usage | {n files} | {OK/Warning} |
| `console.log` found | {n} | {OK/Warning} |
| TODO/FIXME comments | {n} | {Info} |
| ESLint disables | {n} | {Info} |

### Recommendations

1. {Most important action}
2. {Second priority}
3. {Third priority}
```

---

## Reminders

- Do NOT auto-fix or update anything -- just report
- If `npm audit fix` is needed, suggest the command but don't run it
- Be specific about which vulnerabilities are exploitable vs theoretical
- Keep recommendations actionable and prioritized
