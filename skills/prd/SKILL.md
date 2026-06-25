---
name: prd
description: "Generate a Product Requirements Document (PRD) for a new feature. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out."
user-invocable: true
---

# PRD Generator

Create detailed Product Requirements Documents that are clear, actionable, and suitable for Ralph autonomous execution.

## The Job

1. Receive a feature description from the user
2. Ask 3-5 essential clarifying questions (with lettered options)
3. Generate a structured PRD based on answers
4. Save to `tasks/prd-[feature-name].md`

**Important:** Do NOT start implementing. Just create the PRD.

## Step 1: Clarifying Questions

Ask only critical questions where the initial prompt is ambiguous:

```
1. What is the primary goal of this feature?
   A. Improve user onboarding experience
   B. Increase user retention
   C. Reduce support burden
   D. Other: [please specify]
```

Users can respond with "1A, 2C, 3B" for quick iteration.

## Step 2: PRD Structure

### 1. Introduction/Overview
### 2. Goals
### 3. User Stories (small enough for one Ralph iteration each)
### 4. Functional Requirements (numbered FR-1, FR-2, ...)
### 5. Non-Goals
### 6. Design Considerations (optional)
### 7. Technical Considerations (optional)
### 8. Success Metrics
### 9. Open Questions

## User Story Format

```markdown
### US-001: [Title]
**Description:** As a [user], I want [feature] so that [benefit].

**Acceptance Criteria:**
- [ ] Specific verifiable criterion
- [ ] Typecheck/lint passes
- [ ] **[UI stories]** Verify in browser
```

## Output

- **Location:** `tasks/prd-[feature-name].md`
- **Format:** Markdown

## Checklist

- [ ] Stories are small (one iteration each)
- [ ] Acceptance criteria are verifiable
- [ ] UI stories include browser verification
- [ ] Saved to `tasks/prd-[feature-name].md`
