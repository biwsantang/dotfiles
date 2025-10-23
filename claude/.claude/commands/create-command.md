---
argument-hint: [optional: command name or description]
description: Create a new slash command with proper structure and best practices
---

# Command Creator Assistant

Create new Claude slash commands following official best practices and established conventions.

## Usage

```bash
/create-command
/create-command api-validator
/create-command "command to validate API documentation"
```

## Your Task

You are a command creation specialist. Create well-structured slash commands by following this workflow:

### Phase 1: Research the Domain/Topic

**Understand what you're building** before asking questions or creating anything.

If user provided context in `$ARGUMENTS` or command name suggests a specific domain:

1. **Identify the domain**:
   - Video conversion → research ffmpeg, video tools, formats
   - API validation → research OpenAPI, Swagger, validation tools
   - Git workflows → research git commands, best practices
   - Data processing → research relevant tools and libraries
   - Code analysis → research AST tools, linters, static analysis

2. **Research the topic thoroughly**:
   - **WebSearch**: Look up current best practices, popular tools, and common approaches
   - **Codebase search**: Use Grep/Glob to check if related patterns exist in the project
   - **Tool discovery**: Identify what CLI tools, libraries, or commands are commonly used
   - **Documentation**: Find official docs for relevant tools
   - **Common workflows**: Understand typical usage patterns and workflows

3. **Gather domain knowledge**:
   - What tools are available? (ffmpeg, imagemagick, ripgrep, etc.)
   - What are the most popular/recommended tools for this task?
   - What are common workflows and use cases?
   - What are typical command arguments/options?
   - What problems do users commonly face?
   - Are there existing codebase patterns to follow?
   - What are the gotchas or edge cases?

**Skip this phase if**: Command is generic (like "helper command") and doesn't require domain-specific expertise.

### Phase 2: Ask Informed Questions

**Now that you understand the domain**, ask clarifying questions based on your research:

1. **Tool selection**: "I found [tool A] and [tool B] for this - which should we use?" or "Research shows [tool] is most popular - use that?"
2. **Scope**: "Should this handle [common scenarios from research]?"
3. **Arguments**: "Based on [tool], typical args are X, Y, Z - which do you need?"
4. **Integration**: "I see the codebase uses [pattern from search] - should we follow that?"
5. **Edge cases**: "Research shows [common issue] - should we handle that?"
6. **Name**: What should it be called? (suggest kebab-case name based on research)
7. **Type**: Direct execution or skill invocation?
8. **Auto-invocation**: Should SlashCommand tool be able to call this automatically?

### Phase 3: Study Command Structure

Read 2-3 similar commands **for STRUCTURE/FORMAT only** (not content):
- Frontmatter structure and formatting
- How they handle arguments (`$ARGUMENTS`, `$1`, `$2`)
- Section organization and content style
- Tool permission patterns

### Phase 4: Design Structure

Determine command structure:

**File location**: Determine the appropriate location based on context and use case.

**Namespace** (optional):
- Use subdirectories for organization: `.claude/commands/frontend/component.md`
- Subdirectories appear in command description for context

**Frontmatter** (use structured YAML):
```yaml
---
argument-hint: [arg1] [optional-arg2]
description: Brief one-line description for /help display
model: claude-haiku-4-5-20251001  # optional: for lighter tasks
allowed-tools:
  - Read
  - Write
  - Bash:
      - git status
      - git commit
disable-model-invocation: true  # optional: prevent SlashCommand tool from auto-calling
---
```

**Required sections**:
1. Title and overview paragraph
2. Usage examples
3. Context gathering (if needed): `!bash commands` and `@file/references`
4. Task instructions with workflow steps
5. Examples showing expected behavior

### Phase 5: Create the Command

**Template structure**:

```markdown
---
argument-hint: [describe arguments]
description: One-line description
allowed-tools:
  - Tool1
  - Tool2
---

# Command Name

One-paragraph overview of what this command does and when to use it.

## Usage

Basic usage:
\`\`\`bash
/command-name
\`\`\`

With arguments:
\`\`\`bash
/command-name arg1 arg2
/command-name --flag value
\`\`\`

## Context

bash command to gather information
ls -la /path/to/relevant/files

Key files to reference:
- @/path/to/file.md
- @/path/to/another-file.md

User provided context: $ARGUMENTS

## Your Task

Execute the following steps:

1. **Step 1**: Specific action with `$1` parameter
2. **Step 2**: Use `$ARGUMENTS` for all args
3. **Step 3**: Verify success

### Important Notes
- Security consideration or constraint
- Best practice reminder
- Edge case handling

## Examples

**Scenario 1: Basic usage**
\`\`\`
You: /command-name input
Claude: [Expected behavior and output]
\`\`\`

**Scenario 2: With options**
\`\`\`
You: /command-name --option value
Claude: [Different behavior based on option]
\`\`\`
```

**Argument handling**:
- `$ARGUMENTS` - All arguments as single string
- `$1`, `$2`, `$3` - Individual positional arguments
- Document expected format in `argument-hint`

**Bash execution**:
- Commands are executed automatically when present in context
- Specify allowed commands in frontmatter
- Output is included in command context before execution

**File references**:
- Use `@` prefix: `@src/utils/helpers.js`
- Works with files and directories
- Content loaded into context

### Phase 6: Implementation

**Create the command file** at the determined location with proper directory structure.

**Verify**:
- [ ] Frontmatter is valid YAML
- [ ] `description` fits in one line (shown in `/help`)
- [ ] `argument-hint` documents expected arguments
- [ ] `allowed-tools` uses structured format with tool-specific permissions
- [ ] Bash commands use `!` prefix with matching allowed-tools
- [ ] Arguments use `$ARGUMENTS` or `$1`, `$2`, etc.
- [ ] Examples are practical and show expected behavior
- [ ] File uses `.md` extension and kebab-case name

## Command Patterns

### Pattern: Skill Invoker

Commands that activate a skill (lightweight, delegates to skill):

```markdown
---
argument-hint: [options]
description: Brief description
model: claude-haiku-4-5-20251001
---

# Command Name

## Context

git status
git branch -vv

## Your Task

Follow the {Skill Name} skill workflow:
1. Validate prerequisites
2. Execute main workflow from skill
3. Verify and report results

Skill location: `.claude/skills/{skill-name}/SKILL.md`
User arguments: $ARGUMENTS
```

### Pattern: Direct Execution

Commands that execute tasks directly (full instructions in command):

```markdown
---
argument-hint: [required-arg] [optional-arg]
description: Brief description
allowed-tools:
  - Read
  - Write
  - Bash:
      - command1
      - command2
---

# Command Name

## Context

bash command for context gathering

## Your Task

Execute these steps:

1. **Validate input**: Check that $1 is provided and valid
2. **Process**: Perform main work using $ARGUMENTS
3. **Verify**: Confirm success with validation command

Handle errors: [specific error handling instructions]
```

### Pattern: Interactive

Commands that guide users through workflow:

```markdown
---
argument-hint: [optional context]
description: Interactive helper command
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
---

# Command Name

## Your Task

Interactive workflow:

1. **Discovery**: Ask clarifying questions about user needs
2. **Analysis**: Based on responses, determine approach
3. **Execution**: Perform necessary actions
4. **Verification**: Confirm success and provide next steps
```

## Best Practices

**Naming**:
- Use kebab-case: `create-command`, `api-validator`
- Be descriptive but concise
- Avoid redundant prefixes (`cmd-`, `slash-`)

**Frontmatter**:
- Always include `description` and `argument-hint`
- Use structured YAML for `allowed-tools`, not inline arrays
- Specify exact bash commands when possible: `Bash(git status:*)`
- Add `disable-model-invocation: true` if command shouldn't be auto-invoked

**Arguments**:
- Document format in `argument-hint`
- Use `$ARGUMENTS` for all args or `$1`, `$2` for specific ones
- Validate required arguments in task instructions

**Context gathering**:
- Bash commands are executed automatically when present in context
- Use `@` for files: `@/path/to/file`
- Keep context focused and relevant

**Content**:
- Be concise and actionable
- Use inline examples: `# Description: command example`
- Focus on practical use cases
- Include error handling guidance

**SlashCommand Tool Integration**:
- Commands with `description` can be auto-invoked by Claude via SlashCommand tool
- Character budget: 15,000 chars for all command descriptions combined
- Use `disable-model-invocation: true` to opt out
- Reference commands by name with `/` in prompts to encourage auto-invocation

**Permissions**:
- Tool-specific: `allowed-tools: [Read, Grep]` restricts to those tools only
- Bash-specific: Use `Bash(command:*)` or list exact commands
- No wildcards in permission rules beyond bash command patterns

## Example: Domain Research in Action

**User**: `/create-command convert-video`

**Claude's workflow**:

1. **Phase 1 - Research Domain**:
   ```
   Let me research video conversion tools and best practices...

   [Uses WebSearch]
   - Found ffmpeg: Most popular, supports 100+ formats
   - Found HandBrake: GUI-focused, good for batch conversion
   - Found libav: Alternative to ffmpeg
   - Common formats: mp4, webm, avi, mkv, mov
   - Common use cases: format conversion, compression, resolution change
   - Typical ffmpeg pattern: `ffmpeg -i input.mp4 output.webm`
   ```

2. **Phase 2 - Ask Informed Questions**:
   ```
   Based on research, ffmpeg is the industry standard for video conversion.

   Questions:
   - Should we use ffmpeg? (most versatile option)
   - Common use cases are format conversion and compression - handle both?
   - Should we support batch conversion or single files?
   - Default to common web formats (mp4, webm)?
   ```

3. **Phase 3 - Study Structure**:
   ```
   [Reads existing commands for format patterns]
   - Sees how other commands handle file arguments
   - Notes bash tool permission patterns
   ```

4. **Phase 4-6 - Design & Create**:
   ```
   Creates command with:
   - Real ffmpeg commands and options
   - Common format conversions
   - Proper error handling
   - Informed default settings
   ```

**Result**: Command is both **structurally correct** AND **domain-expert**, not just a template.

## Troubleshooting

**Command not recognized?**
- Verify file is in the correct commands directory
- Check filename ends with `.md`
- Ensure frontmatter YAML is valid (use structured format, not inline)

**Arguments not working?**
- Use `$ARGUMENTS` for all args or `$1`, `$2` for specific
- Document in `argument-hint` frontmatter
- Show examples with different argument patterns

**Bash commands failing?**
- Ensure commands are listed in the Context section
- Add commands to `allowed-tools` with structured YAML
- Use absolute paths when needed

**SlashCommand tool not finding command?**
- Ensure `description` frontmatter is present
- Keep description concise (contributes to 15,000 char budget)
- Remove `disable-model-invocation: true` if present

## Resources

Official documentation:
- Slash Commands: https://docs.claude.com/en/docs/claude-code/slash-commands
- Custom Commands: https://docs.claude.com/en/docs/claude-code/slash-commands#custom-slash-commands
- Permissions: https://docs.claude.com/en/docs/claude-code/iam

---

**Note**: Use subdirectories for namespacing when organizing related commands. Commands with valid `description` can be auto-invoked by SlashCommand tool unless `disable-model-invocation: true` is set.
