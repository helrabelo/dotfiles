# Claude Instructions for Hel Rabelo

## Professional Profile
Hel is a Senior Frontend Developer transitioning to Full-Stack and System Architecture roles.

### Primary Roles
1. **Planetary (Digital Agency)** - Senior Lead Developer
   - Notable clients: Din Tai Fung, The Well, Burlington, Dow Jones
   - Technical leadership and architecture decisions

2. **Plainsight (Computer Vision Startup)** - Senior Full-Stack Developer
   - Client Portal frontend development
   - plainsight-api backend integration

3. **Indie Hacker** - Personal Projects
   - Builds and publishes apps (Wishare, etc.)
   - Rapid prototyping and product development

## Git and Version Control
- Never add "claude" to commit messages or PRs
- Never add "co-authored by Claude" anywhere
- Never build projects - ask user to build on their machine
- Never push code - ask user to push on their machine
- Never run "rm -F" commands
- Use conventional commits: feat:, fix:, chore:, docs:

## Development Workflow
- Check if node_modules exists before suggesting npm install
- Prefer existing dependencies over adding new ones
- Use `npm ci` when package-lock.json exists
- Always check git status before committing

## Documentation & Work History
- Work history tracked via GitHub commits
- No activity logs in CLAUDE.md files
- Reference GitHub for project history and progress
- Focus on clean, maintainable code over verbose logging

## Project Structure
- `/Users/helrabelo/code/work/planetary/` - Planetary projects
- `/Users/helrabelo/code/work/plainsight/` - Plainsight projects
- `/Users/helrabelo/code/personal/` - Personal projects

## Active Projects Quick Access
- DTF: `/Users/helrabelo/code/work/planetary/din-tai-fung-website`
- The Well: `/Users/helrabelo/code/work/planetary/the-well`
- Client Portal: `/Users/helrabelo/code/work/plainsight/client-portal`
- Plainsight API: `/Users/helrabelo/code/work/plainsight/plainsight-api`
- Wishare: `/Users/helrabelo/code/personal/wishare`

## MCP Servers

### Serena MCP (Semantic Code Tools) ✅
- **Installation**: `/Users/helrabelo/serena`
- **Status**: Connected as `serena-global`
- **Purpose**: Semantic code retrieval, symbol navigation, IDE-like capabilities
- **Supported Languages**: Python, TypeScript/JS, Go, Rust, PHP, Ruby, Java, C#

### Context7 MCP (Documentation Helper) ✅
- **Installation**: `/Users/helrabelo/mcp-servers/context7`
- **Status**: Connected
- **Purpose**: Version-specific documentation from libraries
- **Usage**: Add "use context7" to prompts for latest docs

### BrowserTools MCP (Browser Automation) ✅
- **Status**: Connected
- **Purpose**: Browser automation and web interaction
- **Chrome Extension**: Required for full functionality

### Zen MCP (Multi-Model Orchestration) ⚠️
- **Installation**: `/Users/helrabelo/mcp-servers/zen-mcp-server`
- **Status**: Needs API Keys
- **Setup**: Create `.env` file with GEMINI_API_KEY, OPENAI_API_KEY

### Tavily MCP (Web Search) ⚠️
- **Installation**: `/Users/helrabelo/mcp-servers/tavily-mcp`
- **Status**: Needs API Key
- **Setup**: Add TAVILY_API_KEY to `~/.claude.json`

## Quick Commands
```bash
# List all MCP servers
claude mcp list

# Test Serena
uv run --directory /Users/helrabelo/serena serena --help
```
- never add co-authors, never add Claude Code as co-author
- Never add " 🤖 Generated with [Claude Code](https://claude.com/claude-code)" to commit messages