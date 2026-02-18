# Estimate Ticket

Analyze and estimate the complexity, effort, and scope of a ticket before implementation.

## Input Required

$ARGUMENTS

Provide one of:
- Ticket ID (e.g., `DTF-123`, `WELL-456`)
- Ticket URL from Linear
- Description of the task if no ticket exists

---

## Phase 1: Context Gathering

1. **Parse ticket reference** from input
   - Extract ticket ID pattern: `{PROJECT}-{NUMBER}` (e.g., DTF-123, WELL-456, BUR-789)
   - If description provided, work from that

2. **Understand the requirement**
   - What is the desired outcome?
   - Who is the end user affected?
   - What problem does this solve?

3. **Explore the codebase**
   - Identify files/modules that will be affected
   - Understand current implementation patterns
   - Note existing related functionality

---

## Phase 2: Scope Analysis

1. **Identify affected areas**
   - List components/files that need changes
   - Note any shared utilities or services impacted
   - Identify database/schema changes if needed
   - Note any third-party integrations involved

2. **Dependencies & Prerequisites**
   - Are there blocking tickets or unmerged PRs?
   - Are external dependencies needed (packages, APIs)?
   - Is design/UX work complete?
   - Is backend/CMS work needed first?

3. **Risk Assessment**
   - What could go wrong?
   - Are there areas with technical debt?
   - Is this touching critical/fragile code?
   - Are there unknowns that need discovery?

---

## Phase 3: Effort Breakdown

Break the work into discrete tasks:

```markdown
### Task Breakdown

1. **{Task name}** - {Brief description}
   - Files: {list affected files}
   - Complexity: Simple / Medium / Complex

2. **{Task name}** - {Brief description}
   - Files: {list affected files}
   - Complexity: Simple / Medium / Complex

... (continue for all tasks)
```

### Complexity Definitions

| Level | Description | Characteristics |
|-------|-------------|-----------------|
| **Simple** | Straightforward change | Single file, clear pattern to follow, minimal testing |
| **Medium** | Moderate complexity | Multiple files, some decisions needed, standard testing |
| **Complex** | Significant work | Many files, architectural decisions, edge cases, extensive testing |
| **Spike** | Unknown scope | Needs investigation before estimating |

---

## Phase 4: Generate Estimate

### Estimate Format

```markdown
## Ticket Estimate: {TICKET-ID}

**Title:** {ticket title or description}
**Estimated Complexity:** Simple / Medium / Complex / Spike

---

### Summary
{1-2 paragraph overview of what this ticket involves}

### Scope
- **Components affected:** {list}
- **New files needed:** {list or "None"}
- **External dependencies:** {list or "None"}
- **CMS/Schema changes:** Yes / No

### Task Breakdown
{Numbered list from Phase 3}

### Risks & Unknowns
- {Risk 1}
- {Risk 2}
- ...

### Prerequisites
- [ ] {Prerequisite 1}
- [ ] {Prerequisite 2}
- ...

### Recommended Approach
{Brief suggested implementation strategy}

---

### Story Points Recommendation

| Approach | Points | Rationale |
|----------|--------|-----------|
| Conservative | X | {why} |
| Optimistic | Y | {why} |
| **Recommended** | **Z** | {why} |

*Using doubling scale: 1, 2, 4, 8, 16*
```

---

## Phase 5: Deliverables

Provide the user with:

1. **Full Estimate** - Complete format from Phase 4

2. **Quick Summary** - For standup/planning:
   ```
   {TICKET-ID}: {title}
   Complexity: {level} | Points: {recommended}
   Key risks: {1-2 main concerns}
   ```

3. **Questions for Stakeholders** - If any clarifications needed before accurate estimate:
   ```
   Before finalizing estimate, need clarity on:
   - {Question 1}
   - {Question 2}
   ```

4. **Linear Comment** - Ready to paste:
   ```
   Estimate: {points} points ({complexity})

   Scope:
   - {key task 1}
   - {key task 2}

   Risks: {brief risk summary}
   ```

---

## Estimation Guidelines

### Story Point Reference (Doubling Scale)

| Points | Meaning | Example |
|--------|---------|---------|
| **1** | Trivial | Copy change, config update, single-line fix |
| **2** | Small | Single component fix, add field, simple bugfix |
| **4** | Medium | New component following pattern, multiple files |
| **8** | Large | Complex feature, multiple systems, architectural work |
| **16** | Epic | Major feature, should consider breaking down |

### Red Flags (Bump up a level)
- Touching authentication/payments (consider next level up)
- No existing pattern to follow (consider next level up)
- Multiple team dependencies (consider next level up)
- Unclear requirements (spike first, then estimate)
- First time with this technology (consider next level up)

### Green Flags (Stay conservative)
- Clear existing pattern to follow
- Similar work done recently
- Well-defined requirements
- Isolated scope

---

## Reminders

- Estimates are educated guesses, not commitments
- When in doubt, estimate higher
- Flag unknowns that need spikes/discovery
- Consider QA and testing in the estimate
- Ask for clarification on ambiguous requirements
