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

## When to Use [Tool/Skill] vs Alternatives

**Use [Tool/Skill] when**:
- Scenario 1 requiring this tool
- Scenario 2 where it excels

**Use [Alternative] when**:
- Scenario where alternative is better
- Simpler approach suffices

## Installation Check

```bash
# Verify installation
which <tool-name> || echo "<tool-name> not installed"

# Install if needed
brew install <tool-name>  # or npm/cargo/etc
```

## Basic Usage

```bash
# Common pattern 1 with inline comment
command --flag 'pattern' --option value

# Common pattern 2
command --different-flags

# Advanced pattern with config
command --config file.yml
```

## Key Syntax/Concepts (if applicable)

- `syntax1` - What it does | Example: `example1`
- `syntax2` - What it does | Example: `example2`

## Common Patterns

```bash
# Pattern 1 name: command for use case 1
# Pattern 2 name: command for use case 2
# Pattern 3 name: command for use case 3
```

## Workflow for Complex Tasks

1. **Step 1**: `command` - What it does
2. **Step 2**: Add `--flag` - Preview changes
3. **Step 3**: Use `--apply` - Execute changes
4. **Verify**: `verification-command`

## Advanced Configuration (if needed)

```yaml
# config-file.yml
rule:
  pattern: example
  constraints:
    field: value
```

## Best Practices

- Practice 1 with brief explanation
- Practice 2 with brief explanation
- Practice 3 with brief explanation

## Integration Examples

```bash
# With Tool X: integration command
# With Tool Y: integration command
```

## Troubleshooting

- **Problem 1**: Solution steps, link to docs
- **Problem 2**: Solution steps
- **Problem 3**: Solution steps

## Example Workflows

```bash
# Workflow 1: Description
command --pattern 'example' --action

# Workflow 2: Description (multi-step)
command --pattern '$VAR' --rewrite '$VAR.new'
```

## Resources

- Docs: <url> | Playground: <url> (if applicable)
- GitHub: <url>
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
2. **Be concise**: Use compact formatting with inline examples - aim for clarity over verbosity
3. **Provide concrete examples**: Real commands and code snippets trump abstract descriptions
4. **Use inline comments**: Put examples and explanations on the same line when possible
5. **Consolidate sections**: Merge related patterns instead of creating separate subsections
6. **Include workflows**: Numbered steps for complex tasks, not verbose subsections
7. **Add troubleshooting**: Anticipate common problems with brief, actionable solutions
8. **Link to resources**: Official documentation - keep resource lists minimal
9. **Keep it practical**: Focus on real-world use cases over theoretical coverage
10. **Avoid redundancy**: Don't repeat information across sections or create "Quick Reference" if content is already concise
