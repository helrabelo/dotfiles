# Write Ticket

Create a new Linear ticket with structured title, description, labels, and estimation.

## Input Required

$ARGUMENTS

Provide one of:
- A description of the feature/bug/task to create a ticket for
- A Slack message or conversation to turn into a ticket
- A verbal request to formalize into a ticket

---

## Phase 1: Context Gathering

1. **Understand the request**
   - What is the core problem or need?
   - Who requested this? (stakeholder context)
   - What is the expected outcome?
   - Is this a feature, bug, chore, or spike?

2. **Clarify ambiguities**
   - Ask questions if the scope is unclear
   - Identify implicit requirements
   - Determine urgency/priority signals

3. **Explore related codebase** (if applicable)
   - Identify affected areas
   - Note existing patterns or similar implementations
   - Find relevant files for context

---

## Phase 2: Ticket Classification

### Type Determination

| Type | Description | Indicators |
|------|-------------|------------|
| **Feature** | New functionality | "Add", "Create", "Build", "Implement" |
| **Bug** | Something broken | "Fix", "Broken", "Not working", "Error" |
| **Chore** | Maintenance/cleanup | "Update", "Refactor", "Migrate", "Upgrade" |
| **Spike** | Research/discovery | "Investigate", "Research", "Explore", "POC" |
| **Improvement** | Enhance existing | "Improve", "Optimize", "Enhance" |

### Priority Assessment

| Priority | Criteria |
|----------|----------|
| **Urgent** | Production issue, blocking other work, deadline-driven |
| **High** | Important feature, significant impact, stakeholder priority |
| **Medium** | Normal work, scheduled feature, moderate impact |
| **Low** | Nice-to-have, minor improvement, no deadline |

---

## Phase 3: Scope Analysis

1. **Break down the work**
   - List discrete tasks involved
   - Identify dependencies
   - Note technical considerations

2. **Estimate complexity**
   - Simple (1-2 pts): Single file, clear pattern
   - Medium (4 pts): Multiple files, some decisions
   - Complex (8 pts): Many files, architectural work
   - Epic (16 pts): Should be broken into subtasks

3. **Identify risks**
   - Technical unknowns
   - External dependencies
   - Areas of concern

---

## Phase 4: Generate Ticket Content

### Title Format

Use clear, actionable titles:
- **Feature:** `Add [feature] to [area]` or `Implement [capability]`
- **Bug:** `Fix [issue] in [area]` or `[Area]: [problem description]`
- **Chore:** `Update [thing]` or `Refactor [area]`
- **Spike:** `Investigate [topic]` or `Research [question]`

### Description Template

```markdown
## Summary
{1-2 sentence overview of what needs to be done and why}

## Context
{Background information, user story, or problem statement}
- Who is affected?
- What triggered this request?
- Any relevant links or references?

## Requirements
- [ ] {Requirement 1}
- [ ] {Requirement 2}
- [ ] {Requirement 3}

## Technical Notes
{Optional: Implementation hints, affected files, considerations}

## Acceptance Criteria
- [ ] {Criterion 1 - How do we know this is done?}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

## Out of Scope
{Optional: Explicitly list what this ticket does NOT include}
```

### Label Selection

Select all applicable labels:

**Type Labels:**
- `feature` - New functionality
- `bug` - Something broken
- `chore` - Maintenance work
- `spike` - Research/investigation
- `improvement` - Enhance existing

**Area Labels (project-specific):**
- `frontend` - UI/UX changes
- `backend` - API/server changes
- `cms` - Sanity/CMS changes
- `infrastructure` - DevOps/deployment
- `design` - Design-related

**Priority Labels:**
- `urgent` - Needs immediate attention
- `high-priority` - Important, do soon
- `low-priority` - Nice to have

**Status Labels:**
- `needs-design` - Waiting on design
- `needs-review` - Needs stakeholder input
- `blocked` - Has blockers
- `ready` - Ready to work on

---

## Phase 5: Estimation

### Story Points (Doubling Scale)

| Points | Meaning | Time Equivalent (rough) |
|--------|---------|------------------------|
| **1** | Trivial | < 2 hours |
| **2** | Small | Half day |
| **4** | Medium | 1-2 days |
| **8** | Large | 3-5 days |
| **16** | Epic | 1-2 weeks (should break down) |

### Estimation Factors

Consider adding points for:
- [ ] New technology/pattern (+1-2)
- [ ] Multiple team coordination (+2)
- [ ] Unclear requirements (+2)
- [ ] Touching critical systems (+2)
- [ ] QA/testing complexity (+1-2)

---

## Phase 6: Deliverables

Provide the user with:

### 1. Ticket Title
```
{Clear, actionable title}
```

### 2. Ticket Description
```markdown
{Complete description using template from Phase 4}
```

### 3. Labels
```
Type: {feature/bug/chore/spike/improvement}
Area: {frontend/backend/cms/etc}
Priority: {urgent/high/medium/low}
Other: {any additional labels}
```

### 4. Estimation
```
Story Points: {1/2/4/8/16}
Complexity: {Simple/Medium/Complex/Epic}
Rationale: {Brief explanation of estimate}
```

### 5. Additional Recommendations (if applicable)
```
- Suggested assignee: {if obvious}
- Suggested sprint/cycle: {if known}
- Related tickets: {if any}
- Should this be broken into subtasks? {Yes/No + suggestions}
```

---

## Output Format

Present the final ticket in a copy-paste ready format:

```
=== LINEAR TICKET ===

TITLE:
{title}

DESCRIPTION:
{full description}

LABELS:
{comma-separated list}

ESTIMATE:
{points} points ({complexity})

NOTES:
{any additional context or recommendations}

===================
```

---

## Reminders

- Keep titles concise but descriptive (under 80 chars)
- Description should be understandable by anyone on the team
- When in doubt about scope, estimate higher
- Include "Out of Scope" if there's risk of scope creep
- Flag if ticket should be broken into smaller tickets
- Ask clarifying questions before finalizing if requirements are vague
