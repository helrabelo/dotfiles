# Root-Level Claude Configuration

## Project Structure
My development projects are organized as follows:
- `/Users/helrabelo/Code/work/planetary/` - All Planetary agency projects
- `/Users/helrabelo/Code/work/plainsight/` - All Plainsight projects
- `/Users/helrabelo/Code/personal/` - Personal projects (Wishare, etc.)

## Active Projects Quick Access
- DTF: `/Users/helrabelo/Code/work/planetary/din-tai-fung-website`
- Client Portal: `/Users/helrabelo/Code/work/plainsight/client-portal`
- Plainsight API: `/Users/helrabelo/Code/work/plainsight/plainsight-api`
- Wishare: `/Users/helrabelo/Code/personal/wishare`

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
- Planetary: `/Users/helrabelo/Code/work/planetary/CLAUDE.md`
- Plainsight: `/Users/helrabelo/Code/work/plainsight/CLAUDE.md`
- Personal: `/Users/helrabelo/Code/personal/CLAUDE.md`

## Recent Activity Log

### 2025-09-19 - Plainsight Client Portal
**Major Achievement**: Comprehensive Filter Library Implementation
- **Project**: Client Portal Filter Library System
- **Scope**: Strategic restructure, user/project level separation, CSV mock data integration
- **Key Deliverables**:
  - Global Filter Library accessible from all contexts
  - Enhanced project-level Filters with Private/Public tabbed interface
  - 21 realistic filters from CSV inventory (MQTT, Video I/O, Object Detection, etc.)
  - Smart API fallback system with transparent logging
  - Proper navigation structure and layout wrappers
- **Technical Impact**: Resolved circular dependencies, route conflicts, implemented scope management
- **Business Value**: Filter discovery tool now supports both global exploration and project-specific management
