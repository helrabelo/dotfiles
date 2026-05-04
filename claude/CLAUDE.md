# Root-Level Claude Configuration

## Project Structure
My development projects are organized as follows:
- `/Users/helrabelo/code/planetary/` - All Planetary agency projects
- `/Users/helrabelo/code/personal/` - Personal projects (Wishare, etc.)

## Active Projects Quick Access
- DTF: `/Users/helrabelo/code/planetary/din-tai-fung-website`
- The Well: `/Users/helrabelo/code/planetary/the-well`
- Wishare: `/Users/helrabelo/code/personal/wishare`

## Performance Notes
- Always check if node_modules exists before suggesting npm install
- Prefer using existing dependencies over adding new ones
- Clean up node_modules in inactive projects to save space
- Use `npm ci` instead of `npm install` when package-lock.json exists

## Git Workflow
- Never include "Claude" in commit messages
- Use conventional commits: feat:, fix:, chore:, docs:
- Always check git status before committing
- Never push directly, always create PRs

## Daily Log Structure
Track activities in project-specific CLAUDE.md files:
- Planetary: `/Users/helrabelo/code/planetary/CLAUDE.md`
- The Well: `/Users/helrabelo/code/planetary/the-well/CLAUDE.md`
- Personal: `/Users/helrabelo/code/personal/CLAUDE.md`

## MCP Servers

### Serena MCP (Semantic Code Tools)
- **Installation**: `/Users/helrabelo/serena`
- **Global Config**: Configured as `serena-global` MCP server
- **Purpose**: Provides semantic code retrieval and editing tools with IDE-like capabilities
- **Features**: Symbol navigation, language-aware editing, memory persistence, multiple language support
- **Usage**: Available globally in all Claude Code sessions with IDE-assistant context
- **Supported Languages**: Python, TypeScript/JS, Go, Rust, PHP, Ruby, Java, C#, and more

### Context7 MCP (Documentation Helper) ✅
- **Installation**: `/Users/helrabelo/mcp-servers/context7`
- **Status**: Connected
- **Purpose**: Pulls up-to-date, version-specific documentation from libraries
- **Usage**: Add "use context7" to prompts for latest docs
- **API Key**: Optional - Get from [context7.com/dashboard](https://context7.com/dashboard) for higher rate limits

### Zen MCP (Multi-Model Orchestration) ⚠️
- **Installation**: `/Users/helrabelo/mcp-servers/zen-mcp-server`
- **Status**: Needs API Keys Configuration
- **Purpose**: Orchestrate multiple AI models (Gemini, GPT, Ollama, etc.)
- **Features**: Cross-model consensus, conversation threading, code reviews
- **Setup Required**:
  ```bash
  # Create .env file in ~/mcp-servers/zen-mcp-server/
  cd ~/mcp-servers/zen-mcp-server
  cp .env.example .env  # Edit with your API keys
  # Required keys: GEMINI_API_KEY, OPENAI_API_KEY (optional: others)
  ```

### Tavily MCP (Web Search & Extraction) ⚠️
- **Installation**: `/Users/helrabelo/mcp-servers/tavily-mcp`
- **Status**: Needs API Key
- **Purpose**: Real-time web search, data extraction, website mapping
- **API Key Required**: Get from [tavily.com](https://tavily.com)
- **Setup**:
  ```bash
  # Set environment variable in ~/.claude.json
  # Edit the tavily server entry to add env:
  # "env": { "TAVILY_API_KEY": "your-api-key-here" }
  ```

### BrowserTools MCP (Browser Automation) ✅
- **Installation**: Global npm package
- **Status**: Connected
- **Purpose**: Browser automation and web interaction
- **Chrome Extension**: Required for full functionality
  - Download from [GitHub releases](https://github.com/AgentDeskAI/browser-tools-mcp)
  - Install in Chrome as unpacked extension
- **Server**: Run `npx @agentdeskai/browser-tools-server@1.2.0` (port 3025)

### Quick Commands
```bash
# List all MCP servers and status
claude mcp list

# Test Serena
uv run --directory /Users/helrabelo/serena serena --help

# Activate a project in Serena
# (Ask Claude to "Activate project /path/to/project" in conversation)

# Check Zen MCP logs
tail -f ~/mcp-servers/zen-mcp-server/logs/mcp_server.log

# Verify installations
ls ~/mcp-servers/
```

### API Keys Configuration
To configure API keys for MCP servers that need them:

1. **Tavily**: Edit `~/.claude.json` and find the tavily server entry, add:
   ```json
   "env": { "TAVILY_API_KEY": "tvly-your-api-key-here" }
   ```

2. **Zen MCP**: Create `.env` file in `~/mcp-servers/zen-mcp-server/`:
   ```bash
   GEMINI_API_KEY=your-gemini-key
   OPENAI_API_KEY=your-openai-key
   # Optional: ANTHROPIC_API_KEY, OLLAMA_URL, etc.
   ```

3. **Context7**: (Optional) For higher rate limits, add to `~/.claude.json`:
   ```json
   "env": { "CONTEXT7_API_KEY": "your-context7-key" }
   ```


## Hard rule: Never loop non-idempotent actions

NEVER wrap a non-idempotent action (email send, payment, post, push, mutation) in `for i in 1..N`, while-true polling, or any auto-retry construct. Single attempt. If it fails, stop and surface to Hel. Authorization for one execution is authorization for one execution.

Locked 2026-05-02 after Claude sent the same email FIVE TIMES to a paying client's team in a 90-second loop. Full incident: `~/helsky-vault/contexts/ayeeye/incidents/2026-05-02-duplicate-send.md`. Detailed rule in `~/.claude/CLAUDE.md` under "Never Loop Non-Idempotent Actions".


## Hard rule: Pre-flight risk declaration on high-stakes sessions

Before executing the first action in any session prompt that contains irreversible external mutations (multiple sends, pushes, merges, posts, payments, batch authorizations, multi-step "do it all" plans), write a short **"where this is likely to go wrong"** preamble: at least three concrete failure modes, blast radius if each fires, narrowest authorization possible. THEN ask whether the user wants to de-risk before executing.

If fewer than three plausible failure modes come to mind, that is a signal of insufficient thinking, NOT of session safety.

Default to declaring limitations, not to confident execution. The right opener is "here is what I would do, here is where I am most likely to screw it up, want to tighten the leash before I start?" — not "reading the prompt, executing step 1."

Locked 2026-05-02. Detailed rule and history in `~/.claude/CLAUDE.md` under "Pre-flight risk declaration on high-stakes sessions".
