---
argument-hint: [optional: specify target branch, interactive mode, or continue/abort]
description: Rebase current branch with conflict resolution
model: claude-haiku-4-5-20251001
---

# Rebase Command

Use this command to perform safe, effective rebases with intelligent conflict detection and resolution.

## Usage

```
/rebase
```

Or with options:
```
/rebase --interactive
/rebase --onto main
/rebase --continue
/rebase --abort
```

## What This Does

This command activates the **Git Rebase Assistant** skill, which:

1. Validates working directory is clean (stops if uncommitted changes)
2. Creates automatic safety backup branch
3. Detects appropriate base branch automatically
4. Pre-analyzes potential conflicts before starting
5. Provides step-by-step conflict resolution guidance
6. Supports interactive rebase for commit cleanup
7. Helps recover if rebase fails

## Features

- **Automatic safety backups**: Creates `backup/<branch>` before rebasing
- **Smart base detection**: Automatically targets develop or main based on branch type
- **Conflict pre-analysis**: Warns about potential conflicts before starting
- **Step-by-step guidance**: Clear instructions for resolving conflicts
- **Interactive rebase support**: Squash, reorder, and edit commits
- **Easy abort and recovery**: Restore original state if needed
- **Force push warnings**: Alerts about implications for shared branches

## How It Works

The skill will:
1. Validate working directory is clean (stops if uncommitted changes)
2. Fetch latest changes from origin
3. Create safety backup branch: `backup/<branch-name>`
4. Detect appropriate base branch (feature/* → develop, develop → main, etc.)
5. Pre-analyze potential conflicts and warn if detected
6. Execute rebase (standard or interactive based on options)
7. If conflicts occur: provide step-by-step resolution guidance
8. Warn about force push if branch was previously pushed

## Base Branch Detection

The skill automatically determines the rebase target:
- **feature/**, **fix/** branches → `develop` (if exists), else `main`
- **develop** branch → `main`
- **hotfix/** branches → `main`
- **Other** branches → `main`
- **Override**: Use `--onto <branch>` flag

## Rebase Types

**Standard rebase** (default):
```
/rebase
```
Updates branch with latest changes from base, maintaining commit history.

**Interactive rebase**:
```
/rebase --interactive
```
Opens editor to squash, reorder, or edit commits. Great for cleaning up history before PR.

**Continue/Abort**:
```
/rebase --continue  # After resolving conflicts
/rebase --abort     # Cancel and restore original state
```

## Common Scenarios

**Clean rebase**:
```
You: /rebase
Claude: [Creates backup] backup/feature/auth created
        [Fetches and analyzes] No conflicts detected
        Rebasing feature/auth onto develop...
        ✓ Rebase completed successfully
        Note: Branch requires force push (use --force-with-lease)
```

**Rebase with conflicts**:
```
You: /rebase
Claude: [Creates backup and starts rebase]
        ⚠️  Conflict in src/auth.js

        Conflict markers explanation:
        <<<<<<< HEAD (your changes)
        =======
        >>>>>>> develop (incoming changes)

        Resolution options:
        1. Accept incoming (use develop's version)
        2. Accept current (keep your version)
        3. Manual merge (combine both)

        After resolving: git add <file> && /rebase --continue
        To abort: /rebase --abort
```

**Interactive rebase for cleanup**:
```
You: /rebase --interactive
Claude: Opening interactive rebase editor...
        Suggestion: Squash commits e4f5g6h and h7i8j9k (small fixes)

        pick a1b2c3d feat: add authentication
        squash e4f5g6h fix: typo
        squash h7i8j9k fix: linting
        pick k10l11m docs: update auth docs
```

## Conflict Resolution Guide

When conflicts occur, the skill helps you understand:

**Conflict markers**:
```
<<<<<<< HEAD (your current changes)
Your code here
=======
Incoming code from base branch
>>>>>>> main
```

**Resolution approaches**:
- **Accept incoming**: Use base branch changes (your changes become obsolete)
- **Accept current**: Keep your changes (override base branch)
- **Manual merge**: Combine both intelligently (requires understanding both changes)

**After resolving**:
1. Edit files to resolve conflicts
2. Stage resolved files: `git add <files>`
3. Continue rebase: `/rebase --continue`

## Safety Features

**Automatic backups**:
- Creates `backup/<branch-name>` before any rebase
- Restore with: `git reset --hard backup/<branch-name>`

**Pre-conflict warnings**:
- Analyzes changes before rebasing
- Warns if conflicts likely
- Suggests resolution strategy upfront

**Easy recovery**:
- `/rebase --abort` cancels operation
- Backup branch preserved for manual recovery

**Force push warnings**:
- Alerts when rebased branch needs force push
- Recommends `--force-with-lease` over `--force`
- Warns about shared branch implications

## Best Practices

✅ **Do**:
- Rebase before creating PRs (clean history)
- Use interactive rebase to squash WIP commits
- Create backup branches (done automatically)
- Test after rebasing
- Use `--force-with-lease` for force pushes

⚠️  **Don't**:
- Rebase shared/public branches (without team coordination)
- Rebase commits already in production
- Skip testing after rebase
- Use `--force` (use `--force-with-lease` instead)

## Examples

**Update feature branch**:
```
/rebase
# Updates feature/auth with latest develop changes
```

**Clean up commit history**:
```
/rebase --interactive
# Squash "fix typo", "linting" into main feature commit
```

**Rebase onto specific branch**:
```
/rebase --onto main
# Rebase current branch onto main instead of develop
```

---

**Note**: This command leverages the Git Rebase Assistant skill located at `.claude/skills/rebase/`. The skill contains detailed instructions for safe rebasing and can also be invoked automatically by Claude when you mention wanting to rebase your branch.