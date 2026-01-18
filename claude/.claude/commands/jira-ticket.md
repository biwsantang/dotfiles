---
allowed-tools: Bash(jira issue create:*)
argument-hint: [story|bug|task]
description: Create a Jira ticket on PLAT board from conversation context
---

# Create Jira Ticket

Create a Jira ticket on the PLAT project board based on the conversation context.

## Ticket Type

Argument: `$ARGUMENTS`

| Type | When to Use |
|------|-------------|
| `story` (default) | Feature requirements, user stories |
| `bug` | Bug fixes, defects |
| `task` | Technical tasks, maintenance, operational work |

## Templates

### Story Template

```
h2. User Story
As a [role]... I want [feature]... So that [benefit]...

h2. Context
[Business context and current situation]

h2. Acceptance Criteria
* [criterion 1]
* [criterion 2]

h2. Definition of Done
* Code is peer reviewed and approved
* All acceptance criteria has been written in unit test
* All acceptance criteria are met
* Unit tests written and passing
* All test must be passed
* Product increment has been deployed to sit/sandbox and tested
* Light-weight documentation written
* Release notes prepared

h2. References
[Related links, repository URLs]
```

### Bug Template

```
h2. Problem Description
[Clear description of the bug]

h2. Steps to Reproduce
# Step 1
# Step 2

h2. Expected Behavior
[What should happen]

h2. Actual Behavior
[What actually happens]

h2. Environment
* Environment: [prod/staging/dev]
* Service/Component: [affected service]

h2. Acceptance Criteria
* Bug is fixed and verified
* Root cause identified and documented
* Regression tests added

h2. References
[Related links, logs, repository URLs]
```

### Task Template

```
h2. Background
[Context and reason for the task]

h2. Scope of Work
* [task item 1]
* [task item 2]

h2. Acceptance Criteria
* [criterion 1]
* [criterion 2]

h2. References
[Related links, documentation, repository URLs]
```

## Instructions

1. Analyze conversation to extract summary and details
2. Select template based on `$ARGUMENTS` (default: story)
3. Create ticket:

```bash
jira issue create -p PLAT -t [Story|Bug|Task] --no-input \
  -s "[Summary under 100 chars]" \
  -b $'[Description in Jira wiki markup]'
```

4. Report ticket key and URL to user

## Notes

- Use Jira wiki markup (h2., *, #) NOT markdown
- Use `$'...'` for multi-line descriptions
- Include repository URLs if mentioned
