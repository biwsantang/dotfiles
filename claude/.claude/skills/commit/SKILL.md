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

## When to Use Manual Commits vs Git Commands

**Use this skill when**:
- User explicitly requests commit creation
- Creating commits with proper conventional format
- Analyzing changes to determine if they should be split
- Need to generate meaningful commit messages automatically
- Working with staging area and need guidance

**Use direct git commands when**:
- User wants to run specific git commands directly
- Debugging git issues
- Complex git operations beyond basic commits

## Basic Usage Patterns

### Pattern 1: Simple Commit (Auto-stage All Changes)

Analyze and commit all changes:

```bash
# 1. Check status and diffs in parallel
git status & git diff

# 2. Stage all changes (excluding secrets)
git add .

# 3. Create commit with proper format
git commit -m "$(cat <<'EOF'
<type>: <description>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# 4. Verify
git status
```

### Pattern 2: Commit Only Staged Files

Work with already-staged files:

```bash
# 1. Check what's staged
git diff --staged

# 2. If files are staged, commit only those
git commit -m "$(cat <<'EOF'
<type>: <description>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Pattern 3: Split Commits (Multiple Concerns)

When changes involve multiple concerns:

```bash
# 1. Analyze all changes
git diff --stat
git diff

# 2. Stage first group
git add src/auth/* docs/auth.md

# 3. Create first commit
git commit -m "$(cat <<'EOF'
feat: add user authentication system

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# 4. Stage second group
git add package.json package-lock.json

# 5. Create second commit
git commit -m "$(cat <<'EOF'
chore: add authentication dependencies

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Pattern 4: Commit with Detailed Body

For complex changes requiring explanation:

```bash
git commit -m "$(cat <<'EOF'
refactor: simplify error handling in authentication

Replaced try-catch blocks with centralized error handler to reduce
code duplication and improve error logging consistency. This also
makes it easier to add custom error types in the future.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Pattern 5: Handle Pre-commit Hook Changes

When pre-commit hooks modify files:

```bash
# 1. Attempt commit
git commit -m "..."

# 2. If hooks modify files, check authorship
git log -1 --format='%an %ae'

# 3. Check not pushed
git status

# 4. If safe, amend commit
git add .
git commit --amend --no-edit
```

## Conventional Commit Types

Standard types to use based on change nature:

- `feat` - A new feature for the user
- `fix` - A bug fix
- `docs` - Documentation only changes
- `style` - Code style changes (formatting, semicolons, etc.)
- `refactor` - Code change that neither fixes a bug nor adds a feature
- `perf` - Performance improvement
- `test` - Adding missing tests or correcting existing tests
- `build` - Changes to build system or external dependencies
- `ci` - Changes to CI configuration files and scripts
- `chore` - Other changes that don't modify src or test files
- `revert` - Reverts a previous commit

**Scope (optional)**:
```
feat(auth): add password reset functionality
fix(api): resolve timeout issue in user endpoint
```

**Breaking changes**:
```
feat!: remove deprecated API endpoints

BREAKING CHANGE: The /v1/users endpoint has been removed.
Use /v2/users instead.
```

## Analysis Workflow for Commit Splitting

### Step 1: Gather Information (Parallel)

Run these commands concurrently:

```bash
# Get status
git status

# Get staged diff
git diff --staged

# Get unstaged diff
git diff

# Get overview
git diff --stat
```

### Step 2: Analyze Changes

Check for multiple concerns:

1. **Different functionality**: Features vs bug fixes vs refactoring
2. **Different subsystems**: Authentication vs API vs UI changes
3. **Different file types**: Source code vs documentation vs configuration
4. **Different purposes**: Implementation vs tests vs dependencies
5. **Size and complexity**: Very large changes that would be clearer split

### Step 3: Determine Strategy

**Single commit if**:
- All changes relate to one purpose
- Changes are tightly coupled
- Splitting would create incomplete features
- Total diff is reasonably sized

**Split commits if**:
- Multiple independent changes detected
- Different conventional commit types apply
- Changes to unrelated subsystems
- Some changes are cleanup/refactoring alongside features
- Documentation updates separate from code changes

### Step 4: Stage Strategically

Use selective staging for split commits:

```bash
# Stage specific files
git add path/to/file1.js path/to/file2.js

# Stage by pattern
git add src/auth/*

# Stage interactively (patch mode)
git add -p file.js

# Stage all in directory
git add src/components/
```

### Step 5: Create Commit(s)

Always use HEREDOC format for proper message formatting:

```bash
git commit -m "$(cat <<'EOF'
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 6: Verify Success

After each commit:

```bash
git status    # Verify commit created
git log -1    # Review last commit
```

## Common Use Cases

### Use Case 1: Feature Development

```bash
# Single feature implementation
git add src/features/dashboard/*
git commit -m "$(cat <<'EOF'
feat: add user dashboard with activity widgets

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Use Case 2: Bug Fix

```bash
# Bug fix with clear description
git add src/utils/validator.js tests/validator.test.js
git commit -m "$(cat <<'EOF'
fix: resolve email validation for plus addressing

Email validation was rejecting valid addresses with plus signs
(e.g., user+tag@example.com). Updated regex to allow this common
email feature.

Fixes #123

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Use Case 3: Refactoring

```bash
# Refactoring without behavior change
git add src/services/*
git commit -m "$(cat <<'EOF'
refactor: extract API client configuration to separate module

Moved API client setup logic from individual service files to
centralized config module to reduce duplication and simplify updates.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Use Case 4: Documentation

```bash
# Documentation updates
git add README.md docs/*
git commit -m "$(cat <<'EOF'
docs: add API authentication examples and troubleshooting guide

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Use Case 5: Dependency Updates

```bash
# Dependency management
git add package.json package-lock.json
git commit -m "$(cat <<'EOF'
chore: update axios to v1.6.0 for security fixes

Updates axios to address CVE-2023-XXXXX. No breaking changes expected.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Use Case 6: Multiple Related Changes

```bash
# First commit: implementation
git add src/auth/*
git commit -m "$(cat <<'EOF'
feat: implement OAuth2 authentication flow

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# Second commit: tests
git add tests/auth/*
git commit -m "$(cat <<'EOF'
test: add OAuth2 flow integration tests

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# Third commit: documentation
git add docs/authentication.md
git commit -m "$(cat <<'EOF'
docs: document OAuth2 setup and configuration

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

## Commit Message Guidelines

### Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Description Line Rules

- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize first letter: "add feature" not "Add feature"
- No period at the end
- Keep under 72 characters
- Be specific but concise

**Good examples**:
- `feat: add password strength indicator`
- `fix: resolve race condition in data sync`
- `refactor: simplify authentication middleware`

**Bad examples**:
- `feat: Added new feature.` (past tense, capitalized, period)
- `fix: bug fix` (too vague)
- `update: changed some stuff` (unclear type, vague description)

### Body Guidelines

- Wrap at 72 characters
- Explain the "why" not the "what"
- Include motivation for change
- Describe differences from previous behavior
- Reference issues/tickets

### Footer Guidelines

```
Fixes #123
Closes #456
See also: #789

BREAKING CHANGE: removed deprecated /v1/auth endpoint
```

## Security Considerations

### Never Commit Secrets

**Always exclude these files**:
- `.env`, `.env.local`, `.env.production`
- `credentials.json`, `secrets.json`
- `*.pem`, `*.key`, `*.p12`, `*.pfx`
- `config/secrets/*`
- `*.credentials`
- Private keys, API tokens, passwords

**Warning workflow**:
```bash
# Check for potential secrets before staging
git status

# If sensitive files detected, warn user
echo "WARNING: Found potential secret files: .env"
echo "These files should not be committed."

# Exclude from staging
git add . --ignore-errors
# Or be selective
git add src/ docs/ package.json
```

### Handling Sensitive Changes

If user insists on committing sensitive files:
1. Warn clearly about security risks
2. Suggest alternatives (.gitignore, environment variables)
3. Only proceed if user explicitly confirms

## Pre-commit Hook Handling

### Standard Flow

```bash
# 1. Attempt commit
git commit -m "..."

# 2. If hooks fail, read error message
# 3. Fix issues hooks identified
# 4. Try commit again
```

### Hook Modified Files

When hooks auto-fix files:

```bash
# 1. Commit fails with "files modified by hook" message
# 2. Check if safe to amend
git log -1 --format='%an %ae'  # Should show Claude

# 3. Check not pushed
git status  # Should show "ahead of origin"

# 4. Add hook changes and amend
git add .
git commit --amend --no-edit

# 5. If not safe (not Claude's commit), create new commit
git add .
git commit -m "$(cat <<'EOF'
chore: apply pre-commit hook fixes

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Bypassing Hooks

Only when explicitly requested:

```bash
# User must explicitly request --no-verify
git commit --no-verify -m "..."
```

## Best Practices

1. **Atomic commits**: Each commit should represent one logical change
2. **Test before commit**: Ensure code works before committing
3. **Review diffs**: Always review what you're committing
4. **Write clear messages**: Future developers (including you) will thank you
5. **Commit frequently**: Small, frequent commits are better than large ones
6. **Keep commits focused**: Don't mix unrelated changes
7. **Use conventional format**: Makes history more parseable
8. **Reference issues**: Link commits to issue tracker when relevant

## Performance Optimizations

### Parallel Operations

Run independent git commands concurrently:

```bash
# In a single Bash tool call with &
git status & git diff --staged & git diff & wait
```

### Efficient Diff Analysis

```bash
# Quick overview first
git diff --stat

# Only analyze full diff if needed
git diff
```

### Direct Execution

- Use HEREDOC format directly (no temp files)
- Cache staging status to avoid repeated checks
- Minimize git command calls

## Integration with Other Tools

### With Git Hooks

Compatible with:
- pre-commit (formatting, linting)
- commit-msg (message validation)
- prepare-commit-msg (template injection)

### With Changelog Generators

Conventional commits enable automatic changelog generation:
- conventional-changelog
- semantic-release
- standard-version

### With Issue Trackers

Reference issues in commit messages:
```
fix: resolve login timeout issue

Fixes #123
Related to #456
```

## Troubleshooting

**Commit rejected by hooks**:
- Read hook error message carefully
- Fix issues identified
- Retry commit
- If hooks modified files, consider amending

**Wrong commit message**:
```bash
# Amend last commit message (if not pushed)
git commit --amend -m "new message"
```

**Forgot to add files**:
```bash
# Add files and amend (if not pushed)
git add forgotten-file.js
git commit --amend --no-edit
```

**Need to split commit**:
```bash
# Reset last commit (if not pushed)
git reset HEAD~1

# Stage and commit separately
git add file1.js
git commit -m "first commit"
git add file2.js
git commit -m "second commit"
```

**Accidentally committed secrets**:
```bash
# Remove from last commit (if not pushed)
git reset HEAD~1
git add . # restage everything except secrets
git commit -m "..."

# If already pushed, use git-filter-repo or BFG Repo-Cleaner
```

## Examples

### Example 1: Simple Feature Addition

```bash
# Changes: Added new component file
git add src/components/Button.tsx
git commit -m "$(cat <<'EOF'
feat: add reusable Button component with variants

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Example 2: Multiple File Bug Fix

```bash
# Changes: Fixed bug across multiple files
git add src/utils/parser.ts src/services/api.ts tests/parser.test.ts
git commit -m "$(cat <<'EOF'
fix: resolve JSON parsing error for nested objects

Parser was failing on deeply nested objects due to recursion limit.
Increased limit and added proper error handling.

Fixes #789

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Example 3: Split Commits for Feature + Docs

```bash
# First: Feature implementation
git add src/features/export/*
git commit -m "$(cat <<'EOF'
feat: add data export to CSV and JSON formats

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# Second: Documentation
git add docs/export-guide.md README.md
git commit -m "$(cat <<'EOF'
docs: add export feature documentation and examples

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

## Quick Reference

```bash
# Analyze current state (parallel)
git status & git diff --staged & git diff & wait

# Stage all (excluding secrets)
git add .

# Stage specific files
git add path/to/file1 path/to/file2

# Stage by pattern
git add src/**/*.ts

# Create commit with HEREDOC
git commit -m "$(cat <<'EOF'
<type>: <description>

[optional body]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# Verify commit
git status
git log -1

# Amend last commit (if not pushed)
git commit --amend --no-edit

# Reset last commit (if not pushed)
git reset HEAD~1
```

## Resources

- Conventional Commits: https://www.conventionalcommits.org/
- Git documentation: https://git-scm.com/doc
- Git commit best practices: https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project
- Conventional changelog: https://github.com/conventional-changelog/conventional-changelog
