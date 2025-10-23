---
argument-hint: [optional: skill name or topic]
description: Create new Claude Code skills with guided prompts and template generation
---

# Create Skill Command

Use this command to create new Claude Code skills through an interactive guided process that ensures proper structure, comprehensive documentation, and adherence to established patterns.

## Usage

```
/create-skill
```

Or with a skill topic:
```
/create-skill ripgrep
/create-skill "git workflow automation"
```

## Understanding Skills

**Skills are model-invoked**: Claude autonomously decides when to use them based on your request and the Skill's description. This is different from slash commands, which are user-invoked (you explicitly type `/command`).

**Skills come from three sources**:
1. **Personal Skills**: Available across all your projects
2. **Project Skills**: Shared with your team via git
3. **Plugin Skills**: Bundled with installed plugins

**Progressive disclosure**: Claude reads SKILL.md first, then loads supporting files (reference docs, scripts) only when needed to manage context efficiently.

## What This Does

This command helps you create well-structured skills by:

1. Researching existing skills to understand patterns and conventions
2. Interviewing you about the skill's purpose and trigger conditions
3. Determining appropriate directory structure and naming
4. Generating properly formatted SKILL.md following the template
5. Updating the skills README with the new skill entry

## Context

List existing skills to understand patterns and conventions.

Read the skill documentation and template if available.

Study existing skills for patterns:
- Review 2-3 similar skills for structure and style
- Note how they format frontmatter and trigger descriptions
- Observe their use of inline examples and compact formatting

## Your Task

Create a new Claude Code skill following the established template and best practices.

### Phase 1: Research and Discovery

**List existing skills** to understand patterns and avoid duplication.

**Read similar skills** to understand:
- Frontmatter structure and trigger phrases
- Content organization and section usage
- Example formatting and inline documentation
- Level of detail and conciseness

**Ask clarifying questions**:
1. What tool, capability, or workflow does this skill provide?
2. When should Claude automatically invoke this skill?
3. What are all trigger words/phrases users might say?
4. Is this for a CLI tool, programming technique, or workflow?
5. What similar tools or alternatives exist?
6. Does this skill need restricted tool access? (read-only, specific tools only)
7. Are there package dependencies? (Python packages, npm modules, etc.)

### Phase 2: Planning and Structure

Based on responses and existing patterns, determine:

**Directory naming** (kebab-case):
- Match tool name or primary concept
- Keep short and memorable (e.g., `ast-grep`, `pr`, `commit`)
- Avoid redundant prefixes like `skill-` or `claude-`
- **YAML validation**: Max 64 characters, lowercase letters, numbers, and hyphens only

**Display name** (Title Case):
- Descriptive but concise
- Match common terminology
- Examples: "AST-Grep Code Search", "Pull Request Creation"
- **YAML validation**: Max 1024 characters for description field

**Core responsibilities** (3-5 items):
- What specific tasks does this skill handle?
- What are the primary use cases?
- What problems does it solve?

**Trigger description**:
- List ALL trigger words and phrases
- Include both technical terms and casual language
- Add synonyms and variations
- Examples: "ripgrep", "rg command", "fast search", "regex search"

### Phase 3: Content Generation

Create the skill following this template structure:

```markdown
---
name: skill-name-kebab-case
description: Brief description of when to use this skill. Mention key trigger words like "trigger1", "trigger2", "phrase variation". If packages are required, list them here (e.g., "Requires pypdf and pdfplumber packages").
allowed-tools: Read, Grep, Glob  # Optional: restrict tool access for security/scoping
---

# Skill Display Name

One-paragraph overview of what this skill accomplishes and primary use cases.

**Note**: Skills are model-invoked—Claude autonomously uses this skill when your request matches the description triggers.

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

## Requirements (if applicable)

**For CLI tools**:
```bash
# Verify installation
which <tool-name> || echo "<tool-name> not installed"

# Install if needed
brew install <tool-name>  # or npm/cargo/etc
```

**For packages**: List required packages in the description. Packages must be installed in the user's environment:
```bash
# Example for Python packages
pip install pypdf pdfplumber

# Example for Node packages
npm install --save-dev package-name
```

**Note**: Claude will automatically install required dependencies or ask for permission to install them when needed.

## Basic Usage

```bash
# Common pattern 1 with inline comment
command --flag 'pattern' --option value

# Common pattern 2
command --different-flags
```

## Key Syntax/Concepts (if applicable)

- `syntax1` - What it does | Example: `example1`
- `syntax2` - What it does | Example: `example2`

## Common Patterns

```bash
# Pattern 1 name: command for use case 1
# Pattern 2 name: command for use case 2
```

## Workflow for Complex Tasks

1. **Step 1**: `command` - What it does
2. **Step 2**: Add `--flag` - Preview changes
3. **Step 3**: Use `--apply` - Execute changes
4. **Verify**: `verification-command`

## Best Practices

- Practice 1 with brief explanation
- Practice 2 with brief explanation

## Integration Examples (if applicable)

```bash
# With Tool X: integration command
# With Tool Y: integration command
```

## Troubleshooting

- **Problem 1**: Solution steps, link to docs
- **Problem 2**: Solution steps

## Example Workflows

```bash
# Workflow 1: Description
command --pattern 'example' --action
```

## Resources

- Docs: <url> | Playground: <url> (if applicable)
- GitHub: <url>
```

### Phase 4: Implementation

**Create directory structure** for the new skill.

**Write SKILL.md**:
- Use the template structure above
- Include comprehensive trigger phrases in description
- Add `allowed-tools` if restricting tool access (e.g., read-only skills)
- List package dependencies in description if required
- Provide concrete, tested examples
- Keep content concise with inline formatting
- Focus on practical use cases
- Remember: SKILL.md is loaded first; supporting files loaded only when needed (progressive disclosure)

**Update Skills README**:
- Add to "Existing Skills" section
- Maintain alphabetical order
- Include one-line description with key purpose

**Verify completion**:
- Frontmatter is valid YAML (name max 64 chars, description max 1024 chars)
- `name` uses kebab-case with lowercase letters, numbers, hyphens only
- `description` includes both what the skill does AND when to use it
- `allowed-tools` added if tool restriction needed
- Package dependencies listed in description if required
- All essential sections present (skip optional ones if not needed)
- Examples are accurate and tested
- Trigger phrases are comprehensive

## Content Guidelines

**Be concise**:
- Use inline examples: `# Description: command example`
- Compact formatting over verbose explanations
- Combine related patterns in single code blocks

**Be specific**:
- Include exact commands, not abstract descriptions
- Show real-world use cases
- Provide tested, working examples

**Be practical**:
- Focus on common scenarios
- Include troubleshooting for known issues
- Link to official documentation

**Be consistent**:
- Follow patterns from existing skills
- Match naming conventions
- Use similar structure and formatting

**Avoid verbosity**:
- Skip sections that don't apply
- No "Quick Reference" if already concise
- No redundant explanations across sections

## Quality Checklist

Before finalizing, verify:
- [ ] Researched existing skills for patterns
- [ ] Directory name uses kebab-case (max 64 chars, lowercase/numbers/hyphens)
- [ ] Frontmatter includes name and description
- [ ] Description lists specific trigger words/phrases (max 1024 chars)
- [ ] Description includes BOTH what skill does AND when to use it
- [ ] `allowed-tools` added if tool restriction needed (read-only, specific tools)
- [ ] Package dependencies listed in description if required
- [ ] Clear one-paragraph overview included
- [ ] Note about model-invoked nature added (Claude autonomously decides to use)
- [ ] Core responsibilities listed (3-5 items)
- [ ] "When to Use" compares with alternatives
- [ ] Installation/requirements instructions included (if applicable)
- [ ] Basic usage examples are practical and inline
- [ ] Common patterns use compact format
- [ ] Workflow steps are numbered and clear
- [ ] Best practices are concise and actionable
- [ ] Troubleshooting covers common issues
- [ ] Resources include docs and GitHub links
- [ ] Skills README updated with new skill
- [ ] Content is concise, avoiding verbosity
- [ ] All examples tested and working
- [ ] Supporting files structure explained (progressive disclosure)

## Example Session

**Creating a ripgrep skill**:

```
User: /create-skill ripgrep

Claude: Let me check existing skills first...
[Lists skills and reads ast-grep for pattern reference]

I see the pattern. Let me ask a few questions:

1. What should Claude use ripgrep for specifically?
2. When should it use ripgrep vs the built-in Grep tool?
3. What trigger phrases should invoke this skill?

User: For fast regex searching when I mention "rg" or "ripgrep"

Claude: Perfect! I'll create:
- Directory: ripgrep
- Display name: "Ripgrep Code Search"
- Triggers: "ripgrep", "rg", "fast search", "regex search"

[Creates directory, writes SKILL.md with template, updates README]

✓ Created skill directory and SKILL.md
✓ Updated skills README

The skill is ready! It will be invoked when you mention ripgrep or related terms.
```

## Advanced Options

If you want to modify the skill template itself, edit the skills README.

If you need to update multiple skills, consider creating a batch script or use this command multiple times.

---

## Key Concepts to Remember

**Model-invoked vs User-invoked**:
- Skills are **model-invoked**: Claude autonomously decides when to use them based on description
- Slash commands are **user-invoked**: You explicitly type `/command` to trigger them

**Three Skill Sources**:
1. **Personal Skills**: Your personal skills across all projects
2. **Project Skills**: Team-shared skills in git repositories
3. **Plugin Skills**: Bundled with installed Claude Code plugins

**Progressive Disclosure**:
- Claude reads SKILL.md first
- Supporting files (reference docs, scripts) loaded only when needed
- This manages context efficiently

**Tool Restriction with allowed-tools**:
- Use `allowed-tools` frontmatter to limit which tools Claude can use
- Useful for read-only skills, security-sensitive workflows, or limited scope
- Example: `allowed-tools: Read, Grep, Glob` for read-only access

**Package Requirements**:
- List required packages in the description field
- Packages must be installed in user's environment
- Claude will auto-install or ask permission when needed

---

**Note**: Each skill should focus on a specific tool, technique, or workflow and include comprehensive trigger phrases so Claude knows when to invoke it automatically.
