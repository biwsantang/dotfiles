---
argument-hint: [optional: describe what this PR does or specify draft/base branch]
description: Create or update a pull request
model: claude-haiku-4-5-20251001
---

# Pull Request Command

Use this command to create or update well-formatted pull requests using the GitHub CLI.

## Usage

```
/pr
```

Or with options:
```
/pr --draft
/pr --base develop
/pr --reviewer @username
```

## What This Does

This command activates the **Pull Request Creator** skill, which:

1. Validates all changes are committed and pushed
2. Determines appropriate base branch (develop vs main) automatically
3. Analyzes ALL commits since branch divergence
4. Generates comprehensive PR title and description
5. Creates new PR or updates existing PR gracefully
6. Supports PR templates from `.github/pull_request_template.md`

## Features

- **Smart base branch detection**: Automatically targets develop or main based on branch name
- **Existing PR handling**: Updates existing PRs instead of failing
- **PR template support**: Uses your repository's PR template if available
- **Comprehensive analysis**: Reviews all commits, not just the latest
- **Performance optimized**: Parallel git operations for speed
- **Graceful error handling**: Clear guidance for common issues

## How It Works

The skill will:
1. Validate all changes are committed (stops if uncommitted changes exist)
2. Push branch to remote if not already pushed
3. Detect appropriate base branch (feature/* → develop, develop → main, etc.)
4. Analyze all commits since branch divergence
5. Check for existing PR - if exists, update it; if not, create new one
6. Return PR URL when complete

## Base Branch Detection

The skill automatically determines the target branch:
- **feature/**, **fix/** branches → `develop` (if exists), else `main`
- **develop** branch → `main`
- **hotfix/** branches → `main`
- **Other** branches → `main`
- **Override**: Use `--base <branch>` flag

## Common Scenarios

**Creating new PR**:
```
You: /pr
Claude: [Analyzes commits] Creating PR for feat/auth → develop
        Title: "feat: add user authentication system"
        PR created: https://github.com/user/repo/pull/42
```

**Updating existing PR**:
```
You: /pr
Claude: [Detects existing PR] PR already exists for this branch
        Updating PR with latest changes...
        PR updated: https://github.com/user/repo/pull/42
```

**With options**:
```
You: /pr --draft --base main
Claude: Creating draft PR targeting main branch...
        Draft PR created: https://github.com/user/repo/pull/43
```

## Supported Options

- `--draft`: Create as draft PR
- `--base <branch>`: Override base branch detection
- `--reviewer <users>`: Request specific reviewers
- `--assignee <users>`: Assign PR to users
- `--label <labels>`: Add labels to PR

## Examples

**Good PR titles**:
- `feat: add user authentication system`
- `fix: resolve memory leak in rendering process`
- `docs: update API documentation`
- `refactor: simplify error handling`

**Good PR descriptions**:
- Clear summary of what changed and why
- Link to related issues (e.g., "Closes #123")
- Testing steps for reviewers
- Checklist of changes

---

**Note**: This command leverages the Pull Request Creator skill located at `.claude/skills/pr/`. The skill contains detailed instructions for creating optimal PRs and can also be invoked automatically by Claude when you mention wanting to create a pull request.