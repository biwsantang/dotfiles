---
name: Git Commit Helper
description: Creates well-formatted conventional commits with intelligent change analysis. Use when creating commits, committing changes, staging files, or when the user mentions "commit", "git commit", or wants to save their work to version control. Analyzes diffs to suggest splitting commits when multiple concerns are detected.
---

# Git Commit Helper

Helps create atomic, well-formatted commits following conventional commit standards. Automatically analyzes changes to determine if they should be split into multiple commits.

## Core Responsibilities

1. **Parallel git operations** - Run `git status` and `git diff` concurrently for speed
2. **Smart staging detection** - Check if files are already staged, otherwise auto-stage
3. **Intelligent diff analysis** - Determine if changes should be split into multiple commits
4. **Conventional commit messages** - Generate properly formatted commit messages
5. **Commit attribution** - Add Claude Code attribution to commit messages

## Workflow

### Step 1: Analyze Current State (Parallel Operations)

Run these commands in parallel using Bash tool:
```bash
# Check for staged files
git status

# Get diff of changes (staged if any, otherwise all changes)
git diff --staged

# If no staged files, also check unstaged changes
git diff
```

### Step 2: Determine Staging Strategy

- **If files are staged**: Only commit those specific files
- **If no files staged**: Auto-stage all modified and new files (excluding files that likely contain secrets like .env, credentials.json, etc.)

### Step 3: Analyze Changes for Commit Splitting

Review the diff using `git diff --stat` for overview and full diff for detailed analysis. Check for:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, docs, etc.
3. **File patterns**: Changes to different types of files (source code vs docs vs config)
4. **Logical grouping**: Changes that would be easier to understand separately
5. **Size**: Very large changes that would be clearer if broken down

**If multiple distinct changes detected**:
- Suggest splitting into separate commits
- Help stage changes separately using `git add <specific-files>`
- Create multiple commits with appropriate messages for each group

**If single cohesive change**:
- Proceed with single commit

### Step 4: Generate Commit Message

Use conventional commit format:
```
<type>: <description>

[optional body]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Commit Message Guidelines**:
- Present tense, imperative mood (e.g., "add feature" not "added feature")
- First line under 72 characters
- Focus on "why" rather than "what"
- Match the commit message to the actual changes in the diff

### Step 5: Create Commit(s)

Use HEREDOC format for proper message formatting:
```bash
git commit -m "$(cat <<'EOF'
<type>: <description>

[optional body]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 6: Verify Success

After committing, run `git status` to verify the commit was created successfully.

### Step 7: Handle Pre-commit Hooks

If commit fails due to pre-commit hook changes:
- Check if safe to amend: `git log -1 --format='%an %ae'`
- Check not pushed: `git status` should show "Your branch is ahead"
- If both true: amend the commit
- Otherwise: create a new commit (never amend other developers' commits)

## Conventional Commit Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, whitespace)
- **refactor**: Code changes that neither fix bugs nor add features
- **perf**: Performance improvements
- **test**: Adding or fixing tests
- **chore**: Changes to build process, tools, dependencies
- **build**: Changes related to building the software
- **ci**: Changes to CI/CD scripts or configurations
- **revert**: Undoing a previous commit
- **BREAKING CHANGE**: Changes that might cause breaking behavior

## Examples of Good Commit Messages

**Single purpose commits**:
- `feat: add user authentication system`
- `fix: resolve memory leak in rendering process`
- `docs: update API documentation with new endpoints`
- `refactor: simplify error handling logic in parser`
- `chore: update dependencies to resolve security vulnerabilities`
- `test: add unit tests for transaction validation`

**When to split commits**:

If you see changes like:
- New feature in `src/auth/` + documentation in `docs/` + dependency updates in `package.json`

Split into:
1. `feat: add user authentication system`
2. `docs: document new authentication endpoints`
3. `chore: add authentication dependencies`

## Special Considerations

**Security**:
- NEVER commit files containing secrets (.env, credentials.json, private keys, etc.)
- Warn user if they're attempting to commit sensitive files

**Flags**:
- Support `--no-verify` flag if user explicitly requests it
- Never skip hooks unless explicitly requested

**Best Practices**:
- Create atomic commits (single purpose)
- Keep commits focused and reviewable
- Write clear, descriptive messages
- Reference issue numbers when relevant

## Performance Optimizations

1. **Parallel operations**: Run independent git commands concurrently
2. **Efficient diff analysis**: Use `git diff --stat` for quick overview before full analysis
3. **Smart caching**: Remember staging status to avoid repeated checks
4. **Direct execution**: No temporary files, use HEREDOC for commit messages

## Integration with Other Tools

- Works with standard git pre-commit hooks
- Compatible with conventional-changelog tools
- Follows git best practices for collaboration
