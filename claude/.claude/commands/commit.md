---
argument-hint: [optional context about what you changed]
description: Create a git commit
model: claude-haiku-4-5-20251001
---

# Commit Command

Use this command to create well-formatted conventional commits with intelligent change analysis.

## Usage

```
/commit
```

Or with the --no-verify flag:
```
/commit --no-verify
```

## What This Does

This command activates the **Git Commit Helper** skill, which:

1. Analyzes your staged/unstaged changes using parallel git operations
2. Determines if changes should be split into multiple atomic commits
3. Generates conventional commit messages following best practices
4. Creates commits with proper Claude Code attribution
5. Handles pre-commit hooks gracefully

## Features

- **Intelligent split detection**: Automatically suggests splitting commits when multiple concerns are detected
- **Conventional commit format**: Follows standard commit message conventions (feat, fix, docs, etc.)
- **Performance optimized**: Uses parallel git operations for speed
- **Smart staging**: Auto-stages files if none are staged, or uses existing staged files
- **Security aware**: Warns about committing sensitive files

## How It Works

The skill will:
1. Check current git status and diff in parallel
2. Analyze if changes should be split (different concerns, types, or file patterns)
3. If splitting needed: guide you through staging and committing separately
4. If single commit: create one well-formatted commit
5. Verify success and handle any pre-commit hook issues

## Commit Types

The skill uses conventional commit types:
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation
- `refactor`: Code restructuring
- `chore`: Maintenance tasks
- `test`: Testing changes
- And more...

## Examples

**Single commit scenario**:
```
You: /commit
Claude: [Analyzes changes] I see you've added a new authentication module. Creating commit...
        Created: "feat: add user authentication system"
```

**Multi-commit scenario**:
```
You: /commit
Claude: [Analyzes changes] I see multiple concerns:
        1. New feature in src/auth/
        2. Documentation updates
        3. Dependency changes

        I'll create 3 separate commits for clarity...
        Created: "feat: add user authentication system"
        Created: "docs: document authentication endpoints"
        Created: "chore: add authentication dependencies"
```

## Advanced Options

Pass `--no-verify` to skip pre-commit hooks (use sparingly):
```
/commit --no-verify
```

---

**Note**: This command leverages the Git Commit Helper skill located at `.claude/skills/commit/`. The skill contains detailed instructions for creating optimal commits and can also be invoked automatically by Claude when you mention wanting to commit changes.