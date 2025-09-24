---
description: Execute task with proper CLAUDE.md workflow integration and logging
argument-hint: [task description]
allowed-tools: "*"
---

I need to execute the following task while following your established workflow patterns:

**Task**: $ARGUMENTS

Before starting, I will:
1. Read your global CLAUDE.md instructions from ~/.claude/CLAUDE.md
2. Read any project-specific CLAUDE.md files relevant to the current context
3. Determine the appropriate project context (Planetary, Plainsight, or Personal)
4. Execute the task following your documented conventions
5. Log the work in the appropriate daily log with the format: "For [Company] on [Project]: [Task description] - Problem → Process → Result"

Let me start by reading your configuration files and understanding the current context to properly execute this task.