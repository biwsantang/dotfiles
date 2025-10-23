---
name: Git Rebase Assistant
description: Performs interactive rebases with smart commit management and conflict resolution. Use when rebasing branches, cleaning up commit history, resolving conflicts, or when the user mentions "rebase", "interactive rebase", "squash commits", or wants to update their branch with latest changes from main/develop.
---

# Git Rebase Assistant

Helps perform safe, effective rebases with intelligent conflict detection and resolution guidance. Creates safety backups and provides step-by-step assistance through the entire rebase process.

## Core Responsibilities

1. **Prerequisite validation** - Ensure working directory is clean before rebasing
2. **Safety backup creation** - Create backup branches before destructive operations
3. **Smart base branch detection** - Determine appropriate rebase target
4. **Conflict pre-analysis** - Warn about potential conflicts before starting
5. **Step-by-step conflict resolution** - Guide users through resolving conflicts
6. **Interactive rebase support** - Help with squashing, reordering, and editing commits
7. **Recovery assistance** - Help restore branch state if things go wrong

## When to Use Rebase vs Merge

**Use Rebase when**:
- Updating feature branch with latest main/develop changes
- Cleaning up local commit history before creating PR
- Creating linear, readable git history
- Squashing work-in-progress commits
- Working on branches not yet pushed or shared

**Use Merge when**:
- Working on shared/public branches others depend on
- Preserving exact historical timeline is important
- Merging pull requests into main branch
- You want to avoid force-pushing
- Team prefers merge-based workflows

## Prerequisites Check

Before using git rebase, verify git is available and working directory is clean:

```bash
# Check git is available
which git || echo "git not installed"

# Verify working directory is clean
git status
```

If working directory has uncommitted changes:
```bash
# Option 1: Commit changes
git add .
git commit -m "WIP: save current work"

# Option 2: Stash changes
git stash push -m "Saving work before rebase"

# Option 3: Discard changes (caution!)
git restore .
```

## Basic Usage Patterns

### Pattern 1: Simple Rebase

Rebase current branch onto another branch:

```bash
# Rebase onto main
git rebase main

# Rebase onto develop
git rebase develop

# Rebase onto specific branch
git rebase <target-branch>
```

### Pattern 2: Interactive Rebase

Clean up commit history interactively:

```bash
# Interactive rebase last 3 commits
git rebase -i HEAD~3

# Interactive rebase onto main
git rebase -i main

# Interactive rebase with autosquash
git rebase -i --autosquash main
```

### Pattern 3: Rebase with Conflict Resolution

Handle conflicts during rebase:

```bash
# Start rebase
git rebase main

# If conflicts occur, check status
git status

# After resolving conflicts in files, stage them
git add <resolved-file>

# Continue rebase
git rebase --continue

# Or abort if needed
git rebase --abort
```

### Pattern 4: Rebase Onto Specific Commit

Move commits from one base to another:

```bash
# Rebase current branch onto new base
git rebase --onto <new-base> <old-base>

# Extract commits from one branch to another
git rebase --onto <target> <exclude-from> <include-from>
```

### Pattern 5: Force Push After Rebase

Push rebased branch safely:

```bash
# Safer force push (fails if remote has new commits)
git push --force-with-lease

# Standard force push (use with caution)
git push --force

# Push to specific remote/branch
git push --force-with-lease origin <branch-name>
```

## Interactive Rebase Commands

During interactive rebase, you can use these commands:

- `pick` (p) - Use commit as-is
- `reword` (r) - Use commit, but edit the commit message
- `edit` (e) - Use commit, but stop for amending
- `squash` (s) - Combine commit with previous one, keep both messages
- `fixup` (f) - Like squash, but discard this commit's message
- `drop` (d) - Remove commit
- `exec` (x) - Run shell command after this line

**Example interactive rebase plan**:
```
pick a1b2c3d feat: add user authentication
squash e4f5g6h fix: typo in auth function
fixup h7i8j9k fix: linting issues
reword k10l11m docs: update auth documentation
pick n12o13p test: add auth unit tests
drop p14q15r debug: temporary logging
```

## Common Use Cases

### Use Case 1: Update Feature Branch with Latest Main

```bash
# Fetch latest changes
git fetch origin

# Switch to your feature branch
git checkout feature/my-feature

# Rebase onto latest main
git rebase origin/main

# If successful, force push
git push --force-with-lease
```

### Use Case 2: Squash Multiple WIP Commits

```bash
# Interactive rebase last 5 commits
git rebase -i HEAD~5

# In editor, change 'pick' to 'squash' for commits you want to combine
# Save and exit, then edit combined commit message
```

### Use Case 3: Clean Up Commit Messages

```bash
# Interactive rebase to reword messages
git rebase -i HEAD~3

# Change 'pick' to 'reword' for commits you want to rename
# Save and exit, then edit each message when prompted
```

### Use Case 4: Remove Sensitive Data from History

```bash
# Interactive rebase to drop commits
git rebase -i HEAD~10

# Change 'pick' to 'drop' for commits with sensitive data
# Or delete those lines entirely
```

### Use Case 5: Reorder Commits Logically

```bash
# Interactive rebase
git rebase -i HEAD~5

# Reorder lines to change commit order
# Related commits should be grouped together
```

## Workflow for Safe Rebasing

### Step 1: Validate Prerequisites

Check working directory status and fetch updates:

```bash
# Check for uncommitted changes (MUST be clean)
git status

# Fetch latest changes from remote
git fetch origin

# View current branch info
git branch -vv
```

**Stop if**:
- Working directory has uncommitted changes → commit or stash first
- You're not on the correct branch → checkout target branch

### Step 2: Create Safety Backup

Always create backup before destructive operations:

```bash
# Create backup branch
git branch backup/$(git branch --show-current)

# Verify backup created
git branch | grep backup
```

This allows easy recovery if rebase goes wrong.

### Step 3: Determine Target Base Branch

Smart detection based on current branch:

```bash
# For feature branches → rebase onto develop (or main if no develop)
# For develop branch → rebase onto main
# For hotfix branches → rebase onto main

# Check if develop exists
git show-ref --verify --quiet refs/heads/develop && echo "develop exists"

# List all branches to help decide
git branch -a
```

### Step 4: Pre-analyze Potential Conflicts

Check for likely conflicts before starting:

```bash
# Check for trailing whitespace conflicts
git diff <base-branch>...HEAD --check

# Preview potential merge conflicts
git merge-tree $(git merge-base <base-branch> HEAD) <base-branch> HEAD

# View files changed in both branches
git log --oneline --left-right --cherry-pick <base-branch>...HEAD
```

### Step 5: Execute Rebase

Start the rebase operation:

```bash
# Standard rebase
git rebase <base-branch>

# Interactive rebase
git rebase -i <base-branch>

# Onto rebase (advanced)
git rebase --onto <new-base> <old-base> <branch>
```

### Step 6: Handle Conflicts

If rebase stops due to conflicts:

**Identify conflicts**:
```bash
# Show conflicted files
git status

# List only conflicted file names
git diff --name-only --diff-filter=U

# Show conflict details
git diff
```

**Understand conflict markers**:
```
<<<<<<< HEAD (current branch - yours)
Your changes here
=======
Incoming changes from base branch
>>>>>>> base-branch-name
```

**Resolution options**:
```bash
# Accept theirs (base branch changes)
git checkout --theirs <file>

# Accept ours (your changes)
git checkout --ours <file>

# Manual edit - open file and resolve conflicts manually
# Remove conflict markers and keep desired code
```

**After resolution**:
```bash
# Stage resolved files
git add <resolved-files>

# Continue rebase
git rebase --continue
```

### Step 7: Verify Success and Push

After successful rebase:

```bash
# Verify rebase completed
git status

# View updated commit history
git log --oneline -10

# Check remote status
git status -sb

# Force push with safety check
git push --force-with-lease origin $(git branch --show-current)
```

### Step 8: Clean Up Backup Branch

If rebase was successful and pushed:

```bash
# Delete backup branch
git branch -d backup/<branch-name>

# If branch wasn't merged, force delete
git branch -D backup/<branch-name>
```

## Rebase Types Explained

### Standard Rebase (`git rebase <base>`)

**Purpose**: Move commits to new base
**When**: Updating feature branch with main/develop changes
**Result**: Linear history on top of base branch

**Example**:
```bash
# Before: feature branch diverged from main 5 commits ago
# After: feature commits replayed on latest main
git rebase main
```

### Interactive Rebase (`git rebase -i <base>`)

**Purpose**: Edit, reorder, squash, or remove commits
**When**: Cleaning up history before PR
**Result**: Polished, logical commit history

**Example**:
```bash
# Interactively edit last 5 commits
git rebase -i HEAD~5
```

### Onto Rebase (`git rebase --onto <new> <old> <branch>`)

**Purpose**: Change parent of commits
**When**: Moving commits to different base
**Result**: Commits transplanted to new location

**Example**:
```bash
# Move feature from old-main to new-main
git rebase --onto new-main old-main feature
```

### Autosquash Rebase (`git rebase -i --autosquash`)

**Purpose**: Automatically squash fixup!/squash! commits
**When**: Used fixup/squash commit prefixes
**Result**: Clean history with automated squashing

**Example**:
```bash
# Create fixup commit
git commit --fixup=a1b2c3d

# Later, autosquash during rebase
git rebase -i --autosquash main
```

## Conflict Resolution Strategies

### Understanding Conflict Types

**Code conflicts**: Both branches modified same code
- Solution: Manually merge logic from both sides

**Dependency conflicts**: Different versions of dependencies
- Solution: Choose newer version or test compatibility

**Deletion conflicts**: One branch deleted what other modified
- Solution: Decide if modification should be kept or deleted

**Rename conflicts**: File renamed in one branch, modified in other
- Solution: Apply changes to renamed file

### Resolution Approaches

**Accept incoming** (use base branch changes):
```bash
git checkout --theirs <file>
git add <file>
```

When to use:
- Base branch has correct implementation
- Your changes are obsolete or incorrect

**Accept current** (keep your changes):
```bash
git checkout --ours <file>
git add <file>
```

When to use:
- Your implementation is correct
- Your changes should override base

**Manual merge** (combine both):
```
1. Open file in editor
2. Review conflict markers
3. Combine logic from both sides
4. Remove conflict markers
5. Test the merged code
6. Stage resolved file
```

When to use:
- Both changes are needed
- Need to integrate both sets of logic

### Validation After Resolution

```bash
# Syntax check (language-specific)
npm run lint          # JavaScript/TypeScript
python -m py_compile  # Python
cargo check           # Rust

# Run tests
npm test
pytest
cargo test

# Build check
npm run build
cargo build
```

## Common Scenarios and Solutions

### Scenario 1: Clean Rebase (No Conflicts)

```bash
$ git rebase main
Successfully rebased and updated refs/heads/feature/auth.
```

Action: Verify and push
```bash
git log --oneline -5
git push --force-with-lease
```

### Scenario 2: Conflicts During Rebase

```bash
$ git rebase main
CONFLICT (content): Merge conflict in src/auth.js
error: could not apply a1b2c3d... feat: add authentication
```

Action: Resolve conflicts
```bash
# Check conflicted files
git status

# Resolve conflicts in editor
# Stage resolved files
git add src/auth.js

# Continue rebase
git rebase --continue
```

### Scenario 3: Uncommitted Changes

```bash
$ git rebase main
error: cannot rebase: You have unstaged changes.
```

Action: Stash or commit
```bash
# Stash changes
git stash push -m "WIP before rebase"
git rebase main
git stash pop

# Or commit changes
git add .
git commit -m "WIP: save work"
git rebase main
```

### Scenario 4: Wrong Branch

```bash
$ git rebase main
# Oops, rebased wrong branch!
```

Action: Abort and switch
```bash
git rebase --abort
git checkout correct-branch
git rebase main
```

### Scenario 5: Shared Branch Warning

```bash
$ git push
error: failed to push some refs
hint: Updates were rejected because the tip of your current branch is behind
```

Action: Force push carefully
```bash
# Check if anyone else is using branch
# Communicate with team first!

# Safe force push
git push --force-with-lease

# If that fails, someone pushed - fetch and check
git fetch origin
git log origin/branch..HEAD
```

### Scenario 6: Multiple Conflicts

```bash
$ git rebase main
# First conflict resolved
$ git rebase --continue
# Second conflict appears
```

Action: Resolve iteratively
```bash
# Resolve each conflict as it appears
# After each resolution:
git add <files>
git rebase --continue

# To see how many commits remain:
git log --oneline HEAD..main
```

## Best Practices

### Safety First

✅ **DO**:
- Always create backup branches before rebasing
- Ensure working directory is clean before starting
- Use `--force-with-lease` instead of `--force`
- Test code after resolving conflicts
- Communicate with team about rebased shared branches

❌ **DON'T**:
- Rebase public/shared branches without coordination
- Force push to main/master
- Rebase commits already in production
- Skip testing after conflict resolution
- Ignore backup branch creation

### When to Rebase

✅ **Good times to rebase**:
- Before creating pull request (clean up history)
- Updating feature branch with latest main/develop
- Squashing work-in-progress commits
- On local branches not yet pushed
- After discussion with team on shared branches

❌ **Bad times to rebase**:
- On main/master branch
- On commits already in production
- On public branches without team coordination
- When you're not sure what you're doing (ask first!)

### Interactive Rebase Guidelines

- **Squash WIP commits**: Combine "fix typo", "linting", "debug" commits
- **Reorder logically**: Group related commits together
- **Reword unclear messages**: Make commit messages descriptive and meaningful
- **Remove debug commits**: Delete temporary debugging or console.log commits
- **Keep atomic commits**: Each commit should be a logical unit of change

### Force Push Safety

```bash
# ✅ Safer - fails if remote has new commits
git push --force-with-lease

# ⚠️  Dangerous - overwrites everything
git push --force

# ✅ Best - check remote status first
git fetch origin
git log origin/branch..HEAD
git push --force-with-lease
```

## Recovery from Failed Rebase

### Abort Current Rebase

```bash
# Stop rebase and return to pre-rebase state
git rebase --abort
```

### Restore from Backup Branch

```bash
# Reset to backup
git reset --hard backup/<branch-name>

# Verify restoration
git log --oneline -5
git status
```

### Use Reflog to Find Lost Commits

```bash
# View reflog to find commits before rebase
git reflog

# Reset to specific reflog entry
git reset --hard HEAD@{5}
```

### Complete Recovery Process

```bash
# 1. Abort current rebase
git rebase --abort

# 2. Restore from backup
git reset --hard backup/feature-branch

# 3. Verify state
git status
git log --oneline -10

# 4. Clean up backup if desired
git branch -d backup/feature-branch
```

## Advanced Scenarios

### Rebasing Onto Specific Commit

```bash
# Rebase onto specific commit hash
git rebase <commit-hash>

# Interactive rebase from specific commit
git rebase -i <commit-hash>
```

### Preserving Merge Commits

```bash
# Rebase while keeping merge commits
git rebase --rebase-merges main

# Also known as --preserve-merges (deprecated)
git rebase -p main
```

### Exec Commands During Rebase

```bash
# Run tests after each commit during rebase
git rebase -i --exec "npm test" main

# Multiple commands
git rebase -i --exec "npm run lint && npm test" main
```

### Autosquash Workflow

```bash
# Create fixup commits during development
git commit --fixup=a1b2c3d
git commit --fixup=e4f5g6h

# Later, autosquash during rebase
git rebase -i --autosquash main
```

### Cherry-pick During Rebase

```bash
# If rebase fails, use cherry-pick alternative
git rebase --abort
git checkout main
git checkout -b feature-rebased
git cherry-pick <commit-range>
```

## Integration with Other Tools

### With Git Status and Branch Info

```bash
# Check current rebase status
git status

# View branch relationship
git log --oneline --graph --all

# Check divergence from main
git log --oneline main..HEAD
```

### With Diff Tools

```bash
# Use visual merge tool for conflicts
git mergetool

# Configure merge tool
git config --global merge.tool vimdiff
git config --global mergetool.prompt false
```

### With GitHub/GitLab

```bash
# Fetch PR branch and rebase
gh pr checkout 123
git rebase main
git push --force-with-lease

# Update PR after rebase
# PR automatically updates with force push
```

### With CI/CD Pipelines

```bash
# Rebase in CI (if needed)
git fetch origin main
git rebase origin/main
git push --force-with-lease origin $CI_BRANCH
```

### With Pre-commit Hooks

```bash
# Hooks run during rebase
# If hook fails:
git rebase --continue  # after fixing issues

# Skip hooks if needed (not recommended)
git rebase --no-verify
```

## Troubleshooting

**Rebase stuck or hanging**:
- Check if waiting for editor input (interactive rebase)
- Look for conflict markers that need resolution
- Use `git status` to check current state
- Abort and try again: `git rebase --abort`

**Can't continue after resolving conflicts**:
- Ensure all conflicted files are staged: `git add <files>`
- Check for remaining conflict markers in files
- Verify no syntax errors were introduced
- Use `git diff --check` to find issues

**Lost commits after rebase**:
- Check reflog: `git reflog`
- Restore from backup: `git reset --hard backup/branch`
- Find commit hash and cherry-pick: `git cherry-pick <hash>`

**Force push rejected**:
- Use `--force-with-lease` instead of `--force`
- If still failing, someone else pushed - fetch and review
- Coordinate with team before force pushing

**Detached HEAD state**:
- Create branch at current position: `git checkout -b recovery-branch`
- Or return to previous branch: `git checkout <branch-name>`
- Check reflog to understand what happened

**Interactive rebase editor not opening**:
- Set editor: `git config --global core.editor "vim"`
- Or use: `GIT_EDITOR=vim git rebase -i main`
- Check EDITOR environment variable

## Performance Considerations

1. **Large repositories**: Rebase can be slow on large repos with many commits
2. **Many conflicts**: Resolve conflicts incrementally, don't try to fix everything at once
3. **Binary files**: Conflicts in binary files require choosing one version entirely
4. **Network operations**: Fetch/push operations may be slow on large branches

## Quick Reference

```bash
# Basic rebase
git rebase <base-branch>

# Interactive rebase
git rebase -i <base-branch>
git rebase -i HEAD~<n>

# Continue/abort rebase
git rebase --continue
git rebase --abort
git rebase --skip

# Force push after rebase
git push --force-with-lease
git push --force-with-lease origin <branch>

# Create backup before rebase
git branch backup/<branch-name>

# Restore from backup
git reset --hard backup/<branch-name>

# Resolve conflicts
git status                    # Check conflicted files
git diff                      # View conflicts
git checkout --theirs <file>  # Accept their changes
git checkout --ours <file>    # Accept our changes
git add <file>                # Stage resolved file
git rebase --continue         # Continue rebase

# Advanced rebasing
git rebase --onto <new> <old> <branch>
git rebase -i --autosquash <base>
git rebase --rebase-merges <base>
git rebase -i --exec "npm test" <base>

# Recovery
git reflog                    # Find lost commits
git reset --hard HEAD@{n}     # Restore to reflog entry
```

## Resources

- Official Git docs: https://git-scm.com/docs/git-rebase
- Git Book - Rewriting History: https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History
- Atlassian Git tutorials: https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase
- Interactive rebase guide: https://thoughtbot.com/blog/git-interactive-rebase-squash-amend-rewriting-history
- Git rebase vs merge: https://www.atlassian.com/git/tutorials/merging-vs-rebasing
