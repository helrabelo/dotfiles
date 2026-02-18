# Claude Instructions for Hel Rabelo

## Professional Profile

Hel is a Senior Frontend Developer transitioning to Full-Stack and System Architecture roles.

### Primary Roles
1. **Planetary (Digital Agency)** - Senior Lead Developer
   - Notable clients: Din Tai Fung, The Well, Burlington, Dow Jones
   - Technical leadership and architecture decisions

2. **Indie Hacker (Helsky Labs)** - Personal Projects
   - Builds and publishes apps (DropVox, Days as Numbers, etc.)
   - Rapid prototyping and product development

---

## Hard Rules

These rules exist because of past incidents where destructive actions were taken without permission. They are non-negotiable.

### Destructive Git Commands Are Forbidden

The following commands must never be run without explicit user permission:

- `git checkout --` on any file
- `git restore` on any file
- `git reset` in any form
- `git clean`
- `git stash drop`

Do not revert uncommitted changes for any reason. If the build fails, if there are merge conflicts, or if changes seem problematic, **report the issue and ask the user how to proceed**. Do not decide independently that work should be discarded.

### File and Folder Safety

Never delete files or folders without moving them to a safe location first (e.g., `/tmp` or `~/backup`). Ask the user before deleting anything not explicitly tracked in git. When reorganizing, use `mv` first, verify everything works, then delete. Be aware that nested git repos or sibling projects may exist in the workspace.

### Honesty About Untested Code

Do not claim code works if it has not been executed. Do not imply code is "ready" or "complete" without verification. When presenting written code:

- State explicitly: "I have not tested this yet."
- Warn about assumptions: "This assumes [X] exists."
- If tests were written but not run, say so clearly.

### Attribution

- Never add "Claude", "co-authored by Claude", or any AI attribution to commit messages or PRs
- Never add "Generated with Claude Code" to any output
- Never push code to remote repositories without explicit permission

---

## Development Workflow

### Incremental, Atomic Commits

Work is done incrementally. Each meaningful change should be committed on its own so it is easy to review and revert if needed. Do not accumulate large, multi-concern changesets.

### Build Validation Before Every Commit

Before creating any commit, run the project's build and type-checking commands (e.g., `npm run build`, `tsc --noEmit`, or the equivalent for the project's stack). Do not commit code that has build errors or type errors. If the build fails, fix the issue or report it before committing.

### Test Validation at Task Completion

For multi-step tasks, the individual steps follow the atomic commit + build validation pattern above. However, at the end of the overall task, run the project's test suite to confirm nothing is broken. If tests fail, investigate and fix before reporting the task as complete.

### General Practices

- Check if `node_modules` exists before suggesting `npm install`
- Prefer existing dependencies over adding new ones
- Use `npm ci` when `package-lock.json` exists
- Always check `git status` before committing
- Use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`
- Never run `rm -rf` or `rm -F` commands without permission

---

## Project Structure

| Context | Path |
|---------|------|
| Planetary clients | `/Users/helrabelo/code/work/planetary/` |
| Personal projects | `/Users/helrabelo/code/personal/` |
| Helsky Labs indie | `/Users/helrabelo/code/helsky-labs/` |

### Active Projects

- **DTF**: `/Users/helrabelo/code/work/planetary/din-tai-fung-website`
- **The Well**: `/Users/helrabelo/code/work/planetary/the-well`
- **Helsky Labs**: `/Users/helrabelo/code/helsky-labs/`
- **helrabelo.dev**: `/Users/helrabelo/code/personal/helrabelo.dev`

---

## Documentation

- Work history is tracked via GitHub commits, not CLAUDE.md logs
- Reference GitHub for project history and progress
- Focus on clean, maintainable code over verbose logging

---

## MCP Servers

### Active

| Server | Purpose | Notes |
|--------|---------|-------|
| **Serena** (`serena-global`) | Semantic code retrieval, symbol navigation | `/Users/helrabelo/serena` |
| **Context7** | Version-specific library documentation | Add "use context7" to prompts |
| **BrowserTools** | Browser automation | Requires Chrome extension |

### Needs Configuration

| Server | Purpose | Setup Required |
|--------|---------|----------------|
| **Zen MCP** | Multi-model orchestration | Create `.env` in `~/mcp-servers/zen-mcp-server/` with API keys |
| **Tavily** | Web search & extraction | Add `TAVILY_API_KEY` to `~/.claude.json` |

```bash
# List all MCP servers
claude mcp list

# Test Serena
uv run --directory /Users/helrabelo/serena serena --help
```
