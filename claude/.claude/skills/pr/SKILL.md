---
name: Pull Request Creator
description: Creates and updates well-formatted pull requests using GitHub CLI. Use when creating PRs, pull requests, submitting code for review, or when the user mentions "pr", "pull request", "create pr", or wants to open a code review. Analyzes all commits since branch divergence and handles existing PRs gracefully.
---

# Pull Request Creator

Helps create comprehensive, well-formatted pull requests following best practices. Automatically analyzes branch commits, detects base branches, and handles existing PRs by updating them instead of failing.

## Core Responsibilities

1. **Prerequisite validation** - Ensure all changes are committed and pushed
2. **Parallel git operations** - Run status checks and branch analysis concurrently
3. **Smart base branch detection** - Automatically determine target branch (develop vs main)
4. **Comprehensive commit analysis** - Review ALL commits since branch divergence
5. **PR template support** - Use `.github/pull_request_template.md` if available
6. **Graceful existing PR handling** - Update existing PRs instead of failing
7. **GitHub CLI integration** - Use `gh` commands for PR management

## Workflow

### Step 1: Validate Prerequisites (Parallel Operations)

Run these commands in parallel using Bash tool:
```bash
# Check for uncommitted changes
git status

# Check if branch is pushed to remote
git branch -vv

# Fetch latest changes from origin
git fetch origin
```

**Stop conditions**:
- If uncommitted changes exist: Prompt user to commit first
- If branch not pushed: Auto-push with `git push -u origin <branch>`

### Step 2: Determine Base Branch

Smart base branch detection following Git Flow patterns:

**Feature branches** (e.g., `feature/auth`, `fix/bug-123`):
- Check if `develop` branch exists
- If yes → target `develop`
- If no → target `main`

**Develop branch**:
- Target `main`

**Other branches**:
- Target `main`

**Override**: User can specify `--base <branch>` to override detection

### Step 3: Analyze Commits

Use `git diff` and `git log` to understand all changes:

```bash
# Get commit history since divergence
git log --oneline <base-branch>...HEAD

# Get detailed diff for analysis
git diff --stat <base-branch>...HEAD
git diff <base-branch>...HEAD
```

**Important**: Analyze ALL commits in the branch, not just the latest one!

### Step 4: Check for PR Template

Look for `.github/pull_request_template.md`:
```bash
# Check if template exists
ls .github/pull_request_template.md
```

If template exists:
- Use template structure
- Fill in relevant sections based on commit analysis

If no template:
- Use default PR format

### Step 5: Generate PR Content

**Title**: Brief, descriptive summary of main change
- Use conventional commit style when appropriate
- Focus on the primary purpose of the PR

**Body structure** (default format):
```markdown
## Description
[Describe the changes made and why they were made]

## Related Issue(s)
[Link or list issues this PR addresses, e.g., Closes #123]

## Type of change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## How has this been tested?
[Describe testing performed to ensure changes work as expected]

## Checklist for Reviewers
- [ ] Code follows project style guidelines
- [ ] Tests cover the new functionality or bug fixes
- [ ] Documentation is updated if necessary
- [ ] Changes do not introduce new security vulnerabilities

Generated with [Claude Code](https://claude.ai/code)
```

### Step 6: Create or Update PR

**Check if PR exists**:
```bash
# Check for existing PR for current branch
gh pr view
```

**If no PR exists**:
```bash
# Create new PR using HEREDOC for body
gh pr create --title "<title>" --body "$(cat <<'EOF'
<PR body content>
EOF
)"
```

**If PR already exists**:
```bash
# First read existing PR to understand current state
gh pr view

# Update existing PR with new title and body
gh pr edit --title "<updated-title>" --body "$(cat <<'EOF'
<updated PR body content>
EOF
)"
```

### Step 7: Handle Options and Flags

Support common `gh pr create` flags:
- `--draft`: Create as draft PR
- `--base <branch>`: Override base branch detection
- `--reviewer <users>`: Request specific reviewers
- `--assignee <users>`: Assign PR to users
- `--label <labels>`: Add labels to PR

Example:
```bash
gh pr create --draft --base develop --title "<title>" --body "..."
```

### Step 8: Return PR URL

After successful creation/update, provide the PR URL to user.

## Base Branch Detection Logic

```
Current Branch Pattern → Target Base
========================   ===========
feature/*               → develop (if exists), else main
fix/*                   → develop (if exists), else main
hotfix/*                → main
develop                 → main
release/*               → main
Other                   → main
--base flag             → Override with specified branch
```

## Common Scenarios and Error Handling

### Scenario 1: First Time Creating PR
- **Action**: Create new PR using `gh pr create`
- **Output**: Return new PR URL

### Scenario 2: PR Already Exists
- **Issue**: `GraphQL: A pull request already exists for <branch>`
- **Solution**:
  1. Read existing PR with `gh pr view`
  2. Update PR with `gh pr edit --title "<title>" --body "<body>"`
  3. Inform user that PR was updated

### Scenario 3: Uncommitted Changes
- **Issue**: Working directory has uncommitted changes
- **Solution**: Stop and prompt user to commit changes first

### Scenario 4: Branch Not Pushed
- **Issue**: Current branch doesn't exist on remote
- **Solution**: Push branch with `git push -u origin <branch>`

### Scenario 5: No Commits to PR
- **Issue**: Branch has no commits ahead of base
- **Solution**: Inform user there are no changes to create PR for

## Best Practices for Pull Requests

**Clear titles**:
- Use descriptive titles that summarize main change
- Follow conventional commit style when appropriate
- Examples:
  - `feat: add user authentication system`
  - `fix: resolve memory leak in rendering process`
  - `docs: update API documentation with new endpoints`

**Comprehensive summaries**:
- Include 1-3 bullet points explaining what was changed
- Explain WHY changes were made, not just WHAT
- Link to related issues or discussions

**Test plans**:
- Provide clear steps for reviewers to test changes
- Include both happy path and edge cases
- Mention any special testing considerations

**Atomic PRs**:
- Keep PRs focused on single feature or fix when possible
- Split large changes into multiple PRs for easier review
- Group related changes together logically

## Performance Optimizations

1. **Parallel operations**: Run independent git commands concurrently
2. **Efficient diff analysis**: Use `git diff --stat` for quick overview before detailed analysis
3. **Stream PR body**: Pass content directly to `gh` commands using HEREDOC (no temp files)
4. **Reduce log verbosity**: Use `--oneline` or `--format` for commit analysis
5. **Smart caching**: Remember branch and status info to avoid repeated checks

## Integration with GitHub Features

**PR Templates**:
- Automatically detect and use `.github/pull_request_template.md`
- Fill in template sections based on commit analysis

**Draft PRs**:
- Support `--draft` flag for work-in-progress PRs
- Useful for early feedback or CI testing

**Reviewers and Assignees**:
- Support `--reviewer` and `--assignee` flags
- Can auto-suggest reviewers based on CODEOWNERS file

**Labels**:
- Support `--label` flag for categorizing PRs
- Can auto-detect labels based on commit types

## Security Considerations

- Never include sensitive information in PR descriptions
- Warn if PR includes changes to security-sensitive files
- Ensure all credentials are removed before pushing
- Check for accidentally committed secrets

## Examples

**Simple feature PR**:
```
Title: feat: add user authentication system
Body:
## Description
- Implement OAuth integration with Google and GitHub
- Add JWT token generation and validation
- Create user session management

## Related Issue(s)
Closes #42

## Type of change
- [x] New feature

## How has this been tested?
- Manual testing with Google and GitHub OAuth
- Unit tests for token generation/validation
- Integration tests for session management
```

**Bug fix PR**:
```
Title: fix: resolve memory leak in rendering process
Body:
## Description
Fixed memory leak caused by event listeners not being properly cleaned up when components unmount.

## Related Issue(s)
Fixes #156

## Type of change
- [x] Bug fix

## How has this been tested?
- Memory profiling shows no leak after fix
- Automated tests verify cleanup on unmount
```
