---
description: Rebase current branch with conflict resolution
argument-hint: [optional: specify target branch, interactive mode, or continue/abort]
model: claude-haiku-4-5-20251001
---

# Git Rebase Assistant

git status
git branch -vv | grep '^\*'
git fetch origin --quiet && echo "Fetched latest from origin"

## Context

You have access to the Git Rebase Assistant skill that helps perform safe, effective rebases with intelligent conflict detection and resolution.

The skill provides:
- Automatic safety backup branches before rebasing
- Smart base branch detection (feature/* → develop, develop → main, etc.)
- Pre-conflict analysis and warnings
- Step-by-step conflict resolution guidance
- Interactive rebase support for commit cleanup
- Recovery assistance if rebase fails

## Your task

Use the Git Rebase Assistant skill to help the user rebase their branch safely.

**Arguments**: `$ARGUMENTS` (optional: --interactive, --onto <branch>, --continue, --abort)

**Key responsibilities**:

1. **Validate prerequisites** - Ensure working directory is clean before starting
2. **Create safety backup** - Always create `backup/<branch-name>` before rebasing
3. **Detect base branch** - Auto-detect target branch or use user's specification
4. **Pre-analyze conflicts** - Warn about potential conflicts before starting
5. **Guide through conflicts** - Provide clear resolution steps if conflicts occur
6. **Handle options properly**:
   - No arguments: Standard rebase onto detected base branch
   - `--interactive`: Interactive rebase for commit cleanup
   - `--onto <branch>`: Rebase onto specific branch
   - `--continue`: Continue after resolving conflicts
   - `--abort`: Cancel rebase and restore original state

**Important safety rules**:
- NEVER rebase if working directory has uncommitted changes (stop and prompt user to commit or stash)
- ALWAYS create backup branch before starting any rebase operation
- ALWAYS warn about force push implications for shared branches
- Use `--force-with-lease` instead of `--force` for safer force pushes
- If conflicts occur, explain conflict markers and resolution options clearly

**Base branch detection logic**:
- `feature/*`, `fix/*` → `develop` (if exists), else `main`
- `develop` → `main`
- `hotfix/*` → `main`
- Other branches → `main`
- Override with `--onto <branch>` argument

**Workflow**:
1. Check git status (already done above)
2. Validate working directory is clean
3. Create safety backup: `git branch backup/$(git branch --show-current)`
4. Determine target base branch
5. Pre-analyze potential conflicts: `git diff <base>...HEAD --check`
6. Execute rebase based on arguments
7. If conflicts: Guide through resolution with clear instructions
8. If successful: Warn about force push if branch was previously pushed

**Example handling**:
- `/rebase` → Rebase onto auto-detected base branch
- `/rebase --interactive` → Interactive rebase for squashing commits
- `/rebase --onto main` → Rebase onto main instead of auto-detected branch
- `/rebase --continue` → Continue after resolving conflicts
- `/rebase --abort` → Abort rebase and restore from backup

Refer to the detailed skill documentation at `.claude/skills/rebase/SKILL.md` for comprehensive rebase guidance, conflict resolution strategies, and troubleshooting tips.
