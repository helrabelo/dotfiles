# Sanity Schema

Work with Sanity CMS schemas in Planetary projects.

## Input

$ARGUMENTS

Provide one of:
- `generate {document-type}` -- Scaffold a new schema type
- `types` -- Generate TypeScript types from existing schemas
- `query {description}` -- Generate a GROQ query
- `audit` -- Review schemas for consistency and best practices

---

## Phase 1: Context

1. **Identify the project**
   - Determine which Planetary project we're in
   - Locate the Sanity schema directory (usually `sanity/schemas/` or `studio/schemas/`)
   - Read existing schemas to understand patterns and conventions

2. **Understand project conventions**
   - Field naming patterns (camelCase vs snake_case)
   - How references are structured
   - Existing custom types and objects
   - i18n approach for content

---

## Action: Generate Schema

When creating a new document type or object type:

1. **Examine existing schemas** for the pattern to follow
2. **Ask clarifying questions:**
   - What fields are needed?
   - Is this a document or an object?
   - Does it reference other types?
   - Does it need i18n support?

3. **Generate the schema** following project conventions:
   - Match existing file naming pattern
   - Match existing export pattern
   - Use project's validation approach
   - Include proper `title`, `name`, `type` metadata

4. **Register the schema** -- show where to add the import

---

## Action: Generate Types

When generating TypeScript types from schemas:

1. **Read all schema files** in the schema directory
2. **Generate corresponding TypeScript interfaces**
   - Map Sanity types to TS types (string, number, boolean, etc.)
   - Handle references as typed refs
   - Handle arrays with proper item types
   - Handle image/file types
3. **Output to the project's types directory**

---

## Action: GROQ Query

When generating a GROQ query:

1. **Understand what data is needed** from the description
2. **Read relevant schemas** to know available fields
3. **Generate an optimized GROQ query:**
   - Only fetch needed fields (projections)
   - Handle references with proper dereferencing (`->`)
   - Include proper filtering
   - Add ordering if relevant

4. **Provide the query** with explanation:
   ```groq
   *[_type == "example" && defined(slug)] {
     title,
     slug,
     "author": author->name
   }
   ```

---

## Action: Audit

When auditing schemas:

Check for:
- [ ] Consistent field naming across types
- [ ] Missing `title` or `description` on fields
- [ ] Missing validation rules on required fields
- [ ] Orphaned types (defined but never referenced)
- [ ] Missing `preview` configuration on document types
- [ ] Large schemas that should be split into objects
- [ ] Inconsistent reference patterns

---

## Reminders

- Always read existing schemas before generating new ones
- Follow the project's established patterns exactly
- Ask before creating files -- show the content first
- GROQ queries should be tested by the user against their dataset
