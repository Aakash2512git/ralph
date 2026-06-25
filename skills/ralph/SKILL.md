---
name: ralph
description: "Convert PRDs to prd.json format for the Ralph autonomous agent loop. Use when you have an existing PRD and need Ralph JSON. Triggers on: convert this prd, turn this into ralph format, create prd.json from this, ralph json."
user-invocable: true
---

# Ralph PRD Converter

Converts existing PRDs to `prd.json` for the Ralph + Bob Shell loop.

## The Job

Take a PRD (markdown file or text) and write `prd.json` in your Ralph directory (e.g. `scripts/ralph-bob/prd.json`).

## Output Format

```json
{
  "project": "[Project Name]",
  "branchName": "ralph/[feature-name-kebab-case]",
  "description": "[Feature description]",
  "userStories": [
    {
      "id": "US-001",
      "title": "[Story title]",
      "description": "As a [user], I want [feature] so that [benefit]",
      "acceptanceCriteria": [
        "Criterion 1",
        "Typecheck passes"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

## Story Size: The Number One Rule

**Each story must be completable in ONE Ralph iteration (one context window).**

### Right-sized
- Add a database column and migration
- Add a UI component to an existing page
- Update a server action with new logic

### Too big (split these)
- "Build the entire dashboard"
- "Add authentication"
- "Refactor the API"

## Story Ordering

1. Schema/database changes
2. Server/backend logic
3. UI components
4. Dashboard/aggregate views

## Acceptance Criteria

Must be verifiable. Always include `"Typecheck passes"` (or your project's equivalent).

For UI stories, include `"Verify in browser"`.

## Conversion Rules

1. One JSON entry per user story
2. IDs: US-001, US-002, ...
3. Priority: dependency order first
4. All stories start with `passes: false`
5. `branchName`: `ralph/[feature-kebab-case]`

## Archiving

If replacing an existing `prd.json` for a different feature, archive the old run first (or let `ralph.sh` handle it on next run).

## Checklist

- [ ] Each story fits one iteration
- [ ] Stories ordered by dependency
- [ ] Verifiable acceptance criteria
- [ ] UI stories include browser verification
