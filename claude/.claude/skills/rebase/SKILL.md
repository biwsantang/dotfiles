---
name: Git Rebase Assistant
description: Performs interactive rebases with smart commit management and conflict resolution. Use when rebasing branches, cleaning up commit history, resolving conflicts, or when the user mentions "rebase", "interactive rebase", "squash commits", or wants to update their branch with latest changes from main/develop.
---

# Git Rebase Assistant

Helps perform safe, effective rebases with intelligent conflict detection and resolution guidance. Creates safety backups and provides step-by-step assistance through the entire rebase process.

## Core Responsibilities

1. **Prerequisite validation** - Ensure working directory is clean before rebasing
2. **Safety backup creation** - Create backup branches before destructive operations
3. **Parallel git operations** - Run status checks and fetch concurrently
4. **Smart base branch detection** - Determine appropriate rebase target
5. **Conflict pre-analysis** - Warn about potential conflicts before starting
6. **Step-by-step conflict resolution** - Guide users through resolving conflicts
7. **Interactive rebase support** - Help with squashing, reordering, and editing commits
8. **Recovery assistance** - Help restore branch state if things go wrong

## Workflow

### Step 1: Validate Prerequisites (Parallel Operations)

Run these commands in parallel using Bash tool:
```bash
# Check for uncommitted changes
git status

# Fetch latest changes from origin
git fetch origin

# Analyze current branch
git branch -vv
```

**Stop conditions**:
- If uncommitted changes exist: Prompt user to commit or stash first
- Never proceed with dirty working directory

### Step 2: Determine Target Base Branch

Smart base branch detection:

**Feature branches** (e.g., `feature/auth`, `fix/bug-123`):
- Check if `develop` branch exists
- If yes → rebase onto `develop`
- If no → rebase onto `main`

**Develop branch**:
- Rebase onto `main`

**Hotfix branches**:
- Rebase onto `main`

**Override**: User can specify `--onto <branch>` to override detection

### Step 3: Create Safety Backup Branch

Always create backup before rebasing:
```bash
# Create backup branch
git branch backup/<current-branch-name>
```

Inform user: "Created backup branch `backup/<branch-name>` for safety"

### Step 4: Pre-analyze Potential Conflicts

Check for likely conflicts:
```bash
# Check for conflicting changes
git diff <base-branch>...HEAD --check

# Preview merge conflicts
git merge-tree $(git merge-base <base-branch> HEAD) <base-branch> HEAD
```

If conflicts likely:
- Warn user about potential conflicts
- Suggest conflict resolution strategy
- Ask if they want to proceed

### Step 5: Execute Rebase

Choose appropriate rebase type:

**Standard Rebase**:
```bash
git rebase <base-branch>
```

**Interactive Rebase** (if `--interactive` flag or suggested):
```bash
git rebase -i <base-branch>
```

**Onto Rebase** (if `--onto` specified):
```bash
git rebase --onto <new-base> <old-base> <branch>
```

### Step 6: Handle Conflicts (if they occur)

If rebase stops due to conflicts:

1. **Identify conflicted files**:
```bash
git status
```

2. **Show conflict details**:
```bash
# Show files with conflicts
git diff --name-only --diff-filter=U

# Show conflict markers
git diff
```

3. **Guide conflict resolution**:
   - Explain conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
   - Identify conflict types (code, dependency, merge)
   - Suggest resolution approaches:
     - **Accept incoming**: Take changes from target branch
     - **Accept current**: Keep changes from current branch
     - **Manual merge**: Combine both sets of changes intelligently

4. **After resolving conflicts**:
```bash
# Stage resolved files
git add <resolved-files>

# Continue rebase
git rebase --continue
```

5. **Validate resolution**:
   - Ensure code still works after resolution
   - Check for syntax errors or broken functionality
   - Run tests if available

### Step 7: Handle Rebase Continue/Abort

**Continue rebase** (after resolving conflicts):
```bash
git rebase --continue
```

**Abort rebase** (if user wants to cancel):
```bash
git rebase --abort

# Optionally restore from backup
git reset --hard backup/<branch-name>
```

**Skip commit** (if needed):
```bash
git rebase --skip
```

### Step 8: Post-Rebase Actions

After successful rebase:

1. **Verify success**:
```bash
git status
git log --oneline -10
```

2. **Check if force push needed**:
```bash
git status
```

3. **Warn about force push** if branch was previously pushed:
   - "This branch has been rebased and will require force push"
   - "⚠️  Only force push if you're sure no one else is using this branch"
   - "Use: `git push --force-with-lease`"

4. **Clean up backup branch** (optional):
```bash
git branch -d backup/<branch-name>
```

## Rebase Types and When to Use

### Interactive Rebase (`git rebase -i`)
**Use for**:
- Squashing multiple small commits into logical units
- Reordering commits for better history
- Editing commit messages
- Removing or modifying commits

**Example interactive plan**:
```
pick a1b2c3d feat: add user authentication
squash e4f5g6h fix: typo in auth function
squash h7i8j9k fix: linting issues
pick k10l11m docs: update auth documentation
reword n12o13p test: add auth unit tests
```

### Standard Rebase (`git rebase`)
**Use for**:
- Moving branch to latest base
- Updating feature branch with main/develop changes
- Linear history without modification

### Onto Rebase (`git rebase --onto`)
**Use for**:
- Moving commits from one base to another
- Extracting commits to different branch
- Advanced branch manipulation

## Conflict Resolution Strategies

### Understanding Conflict Markers

```
<<<<<<< HEAD (current branch)
Your changes here
=======
Incoming changes from base branch
>>>>>>> base-branch-name
```

### Resolution Approaches

**Accept incoming** (use base branch changes):
- When base branch has the correct implementation
- When your changes are obsolete

**Accept current** (keep your changes):
- When your implementation is correct
- When you know your changes should override base

**Manual merge** (combine both):
- When both changes are needed
- When you need to integrate both sets of logic
- Requires careful analysis and testing

### Validation After Resolution

After resolving conflicts:
1. **Syntax check**: Ensure code is syntactically valid
2. **Functionality check**: Verify features still work
3. **Test suite**: Run tests if available
4. **Build check**: Ensure project builds successfully

## Common Scenarios and Error Handling

### Scenario 1: Clean Rebase
- No conflicts detected
- Branch history updated successfully
- Ready for push or further development

### Scenario 2: Merge Conflicts
- **Issue**: Conflicting changes between branches
- **Solution**: Guide through conflict resolution process
- Provide step-by-step instructions
- Offer continue, skip, or abort options

### Scenario 3: Uncommitted Changes
- **Issue**: Working directory has uncommitted changes
- **Solution**: Stop and prompt user to:
  - Commit changes (`git commit`)
  - Stash changes (`git stash`)
  - Discard changes (`git restore`)

### Scenario 4: Detached HEAD
- **Issue**: Rebase results in detached HEAD state
- **Solution**: Create recovery branch and restore state

### Scenario 5: Force Push Needed
- **Issue**: Rebased branch needs force push
- **Solution**: Warn about implications and suggest `--force-with-lease`

### Scenario 6: Shared Branch Warning
- **Issue**: Rebasing a branch others might be using
- **Solution**:
  - Warn about force push implications
  - Suggest alternatives (merge instead of rebase)
  - Recommend communicating with team

## Best Practices for Rebasing

### Safety First
- ✅ **Always create backup branches** before destructive operations
- ✅ **Ensure clean working directory** before rebasing
- ✅ **Test after rebase** to ensure functionality works
- ⚠️  **Never rebase shared branches** without team coordination
- ⚠️  **Communicate with team** about rebased shared branches

### When to Rebase
- ✅ Before creating pull requests (clean up history)
- ✅ To update feature branch with latest main/develop
- ✅ To squash work-in-progress commits
- ✅ On local branches not yet pushed
- ❌ On public branches others are using (without coordination)
- ❌ On commits already in production

### Interactive Rebase Best Practices
- **Squash WIP commits**: Combine "fix typo", "linting", etc.
- **Reorder logically**: Put related commits together
- **Reword unclear messages**: Make commit messages descriptive
- **Remove debug commits**: Delete commits that added temporary debugging

### Force Push Safety
- Use `git push --force-with-lease` instead of `--force`
- Check that no one else has pushed to the branch
- Communicate force push to team members
- Consider creating a new branch instead for shared branches

## Safety Features

### Automatic Backup Creation
Before any rebase:
```bash
git branch backup/<branch-name>
```

### Conflict Pre-analysis
Warn about potential conflicts before starting:
- Analyze diff for likely conflicts
- Suggest conflict resolution strategy
- Give user option to proceed or cancel

### Step-by-step Guidance
During conflict resolution:
- Clear instructions for each step
- Explanation of conflict types
- Suggested resolution approaches
- Validation checks

### Easy Abort Option
At any point during rebase:
```bash
git rebase --abort
```

To fully restore from backup:
```bash
git reset --hard backup/<branch-name>
```

### Validation Checks
- Ensure working directory is clean before starting
- Check for unpushed commits
- Warn about shared branch implications
- Verify successful completion

## Examples

### Example 1: Update feature branch with latest develop
```bash
# User: /rebase
# or: "rebase my branch onto develop"

# Skill detects: feature/auth branch → target develop
git fetch origin
git branch backup/feature/auth
git rebase develop
# If conflicts: guide through resolution
# If success: "Rebase completed. Ready to continue development."
```

### Example 2: Interactive rebase to clean up commits
```bash
# User: /rebase --interactive
# or: "squash my last 3 commits"

# Skill suggests interactive rebase plan:
pick a1b2c3d feat: add authentication module
squash e4f5g6h fix: typo in auth
squash h7i8j9k fix: linting

# Result: Clean single commit
```

### Example 3: Conflict resolution
```bash
# During rebase, conflict occurs
# Skill guides:
# "Conflict in src/auth.js - both branches modified the login function"
# "Review the conflict markers and choose resolution approach"
# "After resolving, run: git add src/auth.js && git rebase --continue"
```

## Recovery from Failed Rebase

If rebase goes wrong:

1. **Abort current rebase**:
```bash
git rebase --abort
```

2. **Restore from backup**:
```bash
git reset --hard backup/<branch-name>
```

3. **Verify restoration**:
```bash
git log --oneline -5
git status
```

4. **Clean up if needed**:
```bash
git branch -d backup/<branch-name>
```

## Advanced Scenarios

### Rebasing onto specific commit
```bash
git rebase --onto <new-base> <old-base> <branch>
```

### Autosquash with fixup commits
```bash
git rebase -i --autosquash <base-branch>
```

### Preserving merge commits
```bash
git rebase --rebase-merges <base-branch>
```
