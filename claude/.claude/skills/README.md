# Claude Code Skills

This directory contains custom skills for Claude Code. Skills are specialized capabilities that can be invoked to perform specific tasks more effectively.

## Skill Structure

Each skill should be in its own directory with a `SKILL.md` file that follows this structure:

### Basic Template

```markdown
---
name: Skill Name
description: Brief description of when to use this skill. Mention key trigger words/phrases.
---

# Skill Name

One-paragraph overview of what this skill helps accomplish and its primary use cases.

## Core Responsibilities

1. **Responsibility 1** - Brief description
2. **Responsibility 2** - Brief description
3. **Responsibility 3** - Brief description
4. **Responsibility 4** - Brief description
5. **Responsibility 5** - Brief description

## When to Use This Skill

**Use this skill when**:
- Scenario 1
- Scenario 2
- Scenario 3

**Don't use this skill when**:
- Alternative scenario 1
- Alternative scenario 2

## Installation/Prerequisites (if applicable)

Before using this skill, verify dependencies:
```bash
# Check if tool is available
which <tool-name> || echo "<tool-name> not installed"
```

Installation instructions if needed:
```bash
# Installation commands for various platforms
```

## Basic Usage Patterns

### Pattern 1: Common Use Case Name

Brief description of what this pattern does:

```bash
# Example command or code
<example>
```

### Pattern 2: Another Use Case

Description:

```bash
# Example
<example>
```

### Pattern 3: More Complex Pattern

Description:

```bash
# Example with multiple steps
<example>
```

## Common Use Cases

### Use Case 1: Specific Scenario

```bash
# Detailed example
<example>
```

### Use Case 2: Another Scenario

```bash
# Detailed example
<example>
```

## Workflow for Complex Tasks

### Step 1: First Action

Description and example:

```bash
# Command or code example
```

### Step 2: Second Action

Description and example:

```bash
# Command or code example
```

### Step 3: Verification

How to verify the results:

```bash
# Verification commands
```

## Configuration (if applicable)

Show how to configure the tool/skill for advanced usage:

```yaml
# Example configuration file
key: value
```

## Best Practices

1. **Practice 1**: Description
2. **Practice 2**: Description
3. **Practice 3**: Description
4. **Practice 4**: Description

## Integration with Other Tools

### With Tool X

```bash
# Example of integration
```

### With Tool Y

```bash
# Another integration example
```

## Troubleshooting

**Problem 1**:
- Solution 1
- Solution 2

**Problem 2**:
- Solution 1
- Solution 2

## Resources

- Official docs: <url>
- GitHub: <url>
- Additional resources

## Quick Reference

```bash
# Most common commands
command1
command2
command3
```
```

## Existing Skills

- **ast-grep**: Structural code search and refactoring using AST-based patterns
- **pr**: Create or update pull requests

## Creating a New Skill

1. Create a new directory under `.claude/skills/` with a descriptive name
2. Create a `SKILL.md` file in that directory
3. Follow the template structure above
4. Include clear frontmatter with `name` and `description`
5. Provide concrete examples and use cases
6. Add troubleshooting tips and best practices

## Frontmatter Fields

The YAML frontmatter at the top of `SKILL.md` should include:

- **name**: Human-readable name of the skill
- **description**: When to use this skill, including trigger keywords that Claude should recognize

Example:
```yaml
---
name: AST-Grep Code Search
description: Performs structural code search and refactoring using AST-based patterns. Use when searching for code patterns, refactoring code structurally, finding function calls, class definitions, or when the user mentions "ast-grep", "structural search", "code pattern", or needs to find/replace code that's difficult with regex.
---
```

## Tips for Writing Skills

1. **Be specific about triggers**: Include exact phrases users might say to invoke the skill
2. **Provide concrete examples**: Real commands and code snippets are more helpful than abstract descriptions
3. **Include workflows**: Step-by-step processes for complex tasks
4. **Add troubleshooting**: Anticipate common problems and provide solutions
5. **Link to resources**: Official documentation and helpful external links
6. **Keep it practical**: Focus on real-world use cases over theoretical coverage
7. **Use clear formatting**: Leverage markdown headings, code blocks, and lists for readability
