# Map Codebase

Structured onboarding report for an unfamiliar codebase. Read-only — does not modify any files.

## Input

$ARGUMENTS

Optionally specify project path. Defaults to current working directory.

---

## Phase 1: Discovery

Use parallel Explore agents to survey the codebase. Each agent covers one area:

**Agent 1: Stack & Dependencies**
- Read `package.json`, `Cargo.toml`, `go.mod`, `Gemfile`, `requirements.txt`, or equivalent
- Identify framework, language version, key dependencies
- Note monorepo tools (Turborepo, Nx, Lerna) if present

**Agent 2: Architecture & Routing**
- Map the folder structure (top 3 levels)
- Identify routing pattern (file-based, config-based, etc.)
- Identify data flow pattern (server components, API routes, GraphQL, REST)
- Check for existing CLAUDE.md or similar docs

**Agent 3: State, API & Styling**
- How state is managed (Redux, Zustand, Context, server state, etc.)
- How the app communicates with backends (fetch, Axios, tRPC, SDK)
- CSS approach (Tailwind, CSS Modules, SCSS, styled-components, etc.)

**Agent 4: Testing, Build & Deploy**
- Test framework and how to run tests
- Build commands and output
- CI/CD config (.github/workflows, vercel.json, netlify.toml, etc.)
- Hosting/deployment target

---

## Phase 2: Conventions

After discovery, scan for patterns:

- Naming conventions (files, components, variables)
- Import style (absolute vs relative, barrel files)
- Code organization patterns (feature-based, layer-based)
- Env var patterns (.env files, naming conventions)
- Any existing linting/formatting config (ESLint, Prettier, Biome)

---

## Phase 3: Known Concerns

Look for signals of tech debt or gotchas:

- Migration-in-progress patterns (mixed old/new approaches)
- Deprecated dependency warnings
- TODO/FIXME/HACK comments (count and sample)
- Mixed patterns that suggest a transition (e.g., Pages Router + App Router)

---

## Phase 4: Report

Output a structured markdown summary:

```markdown
## Codebase Map: {project name}

### Stack
- **Framework:** {framework + version}
- **Language:** {language + version}
- **Key deps:** {top 5-8 dependencies}

### Architecture
- **Structure:** {folder organization pattern}
- **Routing:** {routing approach}
- **Data flow:** {how data moves through the app}

### State Management
{approach and key stores/contexts}

### API Layer
{how the app talks to backends}

### Styling
{CSS approach + any design system/component library}

### Testing
- **Framework:** {test framework}
- **Run:** `{test command}`
- **Coverage:** {approximate coverage or "not configured"}

### Build & Deploy
- **Build:** `{build command}`
- **CI/CD:** {pipeline description}
- **Hosting:** {where it deploys}

### Conventions
{key patterns to follow when contributing}

### Known Concerns
{tech debt, migrations in progress, gotchas}
```

---

## Reminders

- This is READ-ONLY — do not create, modify, or delete any files
- Use parallel Explore agents for speed
- If the project has an existing CLAUDE.md, read it first and incorporate its context
- Be specific — "React 19.1" not "React", "Tailwind 4.1" not "Tailwind"
- Flag anything that would surprise a new contributor
