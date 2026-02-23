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

## Writing Voice & Style

When writing blog posts, descriptions, or any long-form content for Hel, follow these guidelines. This is Hel's voice — not a corporate blog, not a Medium thinkpiece.

### Core Influences

**Ryan Holiday's structure** meets **Chandler Bing's delivery** meets **genuine emotional depth**.

Holiday's contribution: open with a bold declarative statement, not a question. State the thesis, then back it with concrete evidence. Short paragraphs. One idea per paragraph. No throat-clearing introductions — start in the middle of the argument if needed. Every sentence should earn its place.

Hel's contribution: the sarcasm, the self-deprecation, the willingness to break the fourth wall and talk directly to the reader like they're sitting across a table.

### Structural Rules

- **Open with a punch.** "The Old Way Is Dead." "This Isn't a Hype Piece." Not "In this article, I will discuss..." The first line should make someone stop scrolling.
- **Short paragraphs.** 1-3 sentences max for emphasis. Let the white space do work.
- **Declarative sentences.** State things. Don't hedge. "This matters because X" not "I think this might be important because maybe X."
- **One-line paragraphs for impact.** Use them sparingly but deliberately.
- **Section headers should be opinionated.** "Why Now, After Eleven Years" not "Background and Motivation."
- **End sections with a transition punch.** A short sentence that closes the thought and pulls toward the next. "Here's the honest version." "This is what I learned."
- **Use numbers and specifics.** "$0.50" not "a small amount." "126 SVGs" not "many files." Concrete beats abstract every time.

### Tone & Personality

- **Break the fourth wall.** Talk to the reader. Acknowledge that you know they're reading a blog post. "If you've gotten this far, you already know why." "Yes, I'm aware that sounds dramatic."
- **Self-deprecating humor.** "If unfinished side projects were a currency, I would be wealthy." This is Hel's natural register — the joke that's also true.
- **Sarcasm, but warm.** Chandler Bing, not House MD. The goal is a knowing wink, not cruelty. Make fun of situations, tools, industry nonsense — not people.
- **Dark humor where it fits.** Don't force it. When something genuinely absurd happens in dev life, name it.
- **Emotional honesty dropped casually.** Not a dramatic confession — just a sentence of vulnerability tucked between technical paragraphs. "That felt wrong." "Something changed." "The breakthrough was simple, almost embarrassing to say out loud." These land harder because they're not performed.
- **Straightforward over diplomatic.** "This doesn't work" not "this may present some challenges." Hel respects the reader enough to be direct.
- **Playful but not silly.** The writing can be fun without being unprofessional. A well-placed analogy > an emoji.

### What to Avoid

- **Corporate voice.** No "leverage," "synergize," "at the end of the day." Ever.
- **AI slant.** No "delve into," "it's worth noting," "in conclusion." These are tells.
- **Hedging.** No "I think maybe perhaps this could potentially be useful." Take a position.
- **Throat-clearing introductions.** No "In this blog post, I'll explore..." Just start.
- **Excessive exclamation marks.** One per post maximum, if any.
- **Generic motivational filler.** No "the journey is the destination" energy. Be specific or be quiet.

### The Holiday + Hel Formula

1. **Bold opening** — a declarative statement that frames the entire piece
2. **The setup** — establish the problem with a personal story or observation
3. **The shift** — "Here's what actually happened" / "This is how it works"
4. **The meat** — concrete, specific, technical when needed, with personality threaded through
5. **The turn** — a moment of reflection or unexpected honesty
6. **The close** — a short, resonant ending. Not a summary. A last thought that lingers.

### Language Preferences

- Em dashes for asides — use them freely
- "That's it." / "That's not nothing." / "That's the actual gain." — Holiday-style punctuation sentences
- Address reader assumptions directly: "It looks like X. That's not what's happening."
- Use "you" to pull the reader in, "I" to anchor in personal experience, switch between them deliberately
- Bilingual references are welcome when natural (Portuguese expressions, Brazilian cultural context)

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
