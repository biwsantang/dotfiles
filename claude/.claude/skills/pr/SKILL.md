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

## When to Use PR Creation vs Manual GitHub UI

**Use this skill when**:
- Need to create PRs quickly from the command line
- Want automated analysis of all commits in the branch
- Need consistent PR formatting across team
- Working with PR templates that should be auto-populated
- Creating multiple PRs in succession
- Integrating PR creation into automated workflows

**Use GitHub UI when**:
- Need to attach screenshots or complex media
- Prefer visual drag-and-drop interface
- Want to browse and compare files visually
- Need to edit PR description with rich formatting
- First time creating a PR in a new repository (to learn the process)

## Installation Check

Before using this skill, verify GitHub CLI is installed and authenticated:

```bash
# Check if gh CLI is available
which gh || echo "gh CLI not installed"

# Check authentication status
gh auth status
```

If not installed, guide the user to install it:
```bash
# Install via homebrew (macOS)
brew install gh

# Install via apt (Ubuntu/Debian)
sudo apt install gh

# Install via winget (Windows)
winget install --id GitHub.cli

# Authenticate with GitHub
gh auth login
```

## Basic Usage Patterns

### Pattern 1: Simple PR Creation

Create a basic PR for current branch:

```bash
# Create PR with auto-detected base branch
gh pr create --title "Add user authentication" --body "Implements JWT-based auth"

# Create PR as draft
gh pr create --draft --title "WIP: Refactor database layer" --body "..."
```

### Pattern 2: PR with Auto-Analysis

Let the skill analyze all commits and generate comprehensive PR:

```bash
# Analyze commits since branch diverged
git log --oneline main...HEAD

# Generate PR description from commit analysis
gh pr create --title "..." --body "$(cat <<'EOF'
## Summary
- Added feature X
- Fixed bug Y
- Updated documentation

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Pattern 3: Update Existing PR

Update an existing PR instead of creating a new one:

```bash
# Check if PR exists for current branch
gh pr view

# Update existing PR with new content
gh pr edit --title "Updated title" --body "Updated description"
```

### Pattern 4: PR with Reviewers and Labels

Create PR with team assignment:

```bash
# Create PR with reviewers and labels
gh pr create \
  --title "Fix memory leak" \
  --body "..." \
  --reviewer @alice,@bob \
  --assignee @me \
  --label bug,priority-high
```

### Pattern 5: Complex PR with Template

Use repository PR template and fill it automatically:

```bash
# Check if template exists
cat .github/pull_request_template.md

# Create PR using template structure
gh pr create --title "..." --body "$(cat <<'EOF'
## Description
[Auto-filled from commit analysis]

## Type of Change
- [x] Bug fix
- [ ] New feature

## Testing
[Auto-generated test plan]
EOF
)"
```

## Workflow Steps

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

## Common Use Cases

### Use Case 1: Feature Branch to Develop

```bash
# Current branch: feature/user-auth
# Target: develop

# 1. Analyze commits
git log --oneline develop...HEAD

# 2. Create PR targeting develop
gh pr create \
  --base develop \
  --title "feat: implement user authentication system" \
  --body "..."
```

### Use Case 2: Hotfix to Main

```bash
# Current branch: hotfix/critical-security-fix
# Target: main (urgent fix)

# 1. Verify fix is committed
git status

# 2. Create PR with priority label
gh pr create \
  --base main \
  --title "fix: patch critical security vulnerability" \
  --body "..." \
  --label security,priority-critical \
  --reviewer @security-team
```

### Use Case 3: Update Existing PR After Review

```bash
# Made changes based on review feedback

# 1. Check existing PR
gh pr view

# 2. Update PR description to reflect changes
gh pr edit --body "$(cat <<'EOF'
## Summary
- Implemented user authentication
- Added password hashing with bcrypt
- Created session management

## Changes from Review
- Fixed race condition in session store
- Added input validation
- Improved error handling

🤖 Updated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Use Case 4: Draft PR for Early Feedback

```bash
# Work in progress, want early feedback

# Create draft PR
gh pr create --draft \
  --title "WIP: Refactor database layer" \
  --body "$(cat <<'EOF'
## Work in Progress

Currently refactoring the database layer to use connection pooling.

### Completed
- [x] Setup connection pool
- [x] Migrate user queries

### In Progress
- [ ] Migrate product queries
- [ ] Add transaction support

### Feedback Needed
- Is the connection pool size appropriate?
- Should we use prepared statements everywhere?
EOF
)"

# Mark as ready when done
gh pr ready
```

### Use Case 5: Multi-Commit Feature PR

```bash
# Branch has multiple related commits

# 1. Analyze all commits in branch
git log --oneline --graph main...HEAD

# Example output:
# * a1b2c3d Add user registration endpoint
# * d4e5f6g Implement password hashing
# * h7i8j9k Add user model and migrations
# * k0l1m2n Setup authentication middleware

# 2. Create comprehensive PR summarizing all changes
gh pr create \
  --title "feat: complete user authentication system" \
  --body "$(cat <<'EOF'
## Summary
Complete implementation of user authentication system including:
- User registration with email validation
- Secure password hashing using bcrypt
- JWT-based session management
- Authentication middleware for protected routes

## Database Changes
- Added users table with migrations
- Added sessions table for token management

## Security Considerations
- Passwords hashed with bcrypt (cost factor: 12)
- JWT tokens expire after 24 hours
- Input validation on all user-submitted data

## Testing
- Unit tests for auth middleware
- Integration tests for registration/login flows
- Manual testing with Postman

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

## Example Workflows

### Workflow 1: Standard Feature PR

Complete workflow from development to PR creation:

```bash
# 1. Ensure all work is committed
git status

# 2. Push branch to remote
git push -u origin feature/new-dashboard

# 3. Analyze what changed
git log --oneline main...HEAD
git diff --stat main...HEAD

# 4. Check for PR template
ls .github/pull_request_template.md

# 5. Create PR
gh pr create \
  --title "feat: add analytics dashboard" \
  --body "..." \
  --reviewer @team/frontend \
  --label enhancement

# 6. Get PR URL
gh pr view --web
```

### Workflow 2: Fix Existing PR

Update PR after making requested changes:

```bash
# 1. View existing PR and comments
gh pr view
gh pr checks

# 2. Made changes based on feedback, now update PR

# 3. Add new commits
git add .
git commit -m "Address review feedback"
git push

# 4. Update PR description to document changes
gh pr edit --body "$(cat <<'EOF'
## Summary
[Original summary]

## Review Changes (Round 1)
- Refactored error handling per @reviewer suggestion
- Added missing test cases
- Fixed TypeScript type errors

## Status
- All tests passing ✅
- No merge conflicts ✅
- Ready for re-review ✅
EOF
)"

# 5. Request re-review
gh pr comment --body "@reviewer Changes addressed, ready for re-review"
```

### Workflow 3: Emergency Hotfix

Fast-track critical fix:

```bash
# 1. Create hotfix branch from main
git checkout main
git pull
git checkout -b hotfix/security-patch

# 2. Make fix
# [make changes]
git add .
git commit -m "fix: patch XSS vulnerability in user input"

# 3. Push and create urgent PR
git push -u origin hotfix/security-patch

gh pr create \
  --base main \
  --title "fix: critical security patch for XSS vulnerability" \
  --body "$(cat <<'EOF'
## Critical Security Fix

Patches XSS vulnerability in user input handling.

## Impact
- Severity: Critical
- Affected versions: All production releases
- CVE: TBD

## Changes
- Sanitize all user input before rendering
- Add Content Security Policy headers
- Escape HTML in user-generated content

## Testing
- Manual testing with XSS payloads
- Automated security scan passed
- No regressions in functionality

## Deployment
Requires immediate deployment to production.
EOF
)" \
  --label security,priority-critical \
  --reviewer @security-team,@tech-leads

# 4. Auto-merge when approved (if configured)
gh pr merge --auto --squash
```

### Workflow 4: Cross-Repository PR

Create PR in a different repository:

```bash
# Working in forked repository

# 1. Add upstream remote
git remote add upstream https://github.com/original/repo.git
git fetch upstream

# 2. Create branch from upstream main
git checkout -b fix/typo upstream/main

# 3. Make changes
# [make changes]
git add .
git commit -m "docs: fix typo in README"

# 4. Push to your fork
git push -u origin fix/typo

# 5. Create PR to upstream repository
gh pr create \
  --repo original/repo \
  --base main \
  --head your-username:fix/typo \
  --title "docs: fix typo in README" \
  --body "Small typo fix in the installation instructions"
```

### Workflow 5: Stacked PRs

Create dependent PRs (advanced):

```bash
# Base: main → feature/base-refactor → feature/dependent-feature

# 1. Create base PR
git checkout -b feature/base-refactor main
# [make changes]
git push -u origin feature/base-refactor

gh pr create \
  --base main \
  --title "refactor: extract shared utilities" \
  --body "..."

# 2. Create dependent PR
git checkout -b feature/dependent-feature feature/base-refactor
# [make changes]
git push -u origin feature/dependent-feature

gh pr create \
  --base feature/base-refactor \
  --title "feat: implement new feature using refactored utilities" \
  --body "$(cat <<'EOF'
## Summary
New feature built on top of refactored utilities.

## Dependencies
⚠️ This PR depends on #123 (base refactor) being merged first.

After #123 is merged, the base of this PR will be changed to main.
EOF
)"

# 3. After base PR merges, update dependent PR base
gh pr edit --base main
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

## Integration with Other Tools

### With Git Hooks

Integrate PR creation into git workflow:

```bash
# In .git/hooks/post-push
#!/bin/bash
BRANCH=$(git symbolic-ref --short HEAD)

if [[ $BRANCH == feature/* ]]; then
  read -p "Create PR for $BRANCH? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    gh pr create --draft
  fi
fi
```

### With CI/CD

Trigger PR creation from CI pipeline:

```yaml
# .github/workflows/auto-pr.yml
name: Auto PR Creation
on:
  push:
    branches:
      - 'feature/**'

jobs:
  create-pr:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Create Pull Request
        run: |
          gh pr create \
            --title "Auto: $(git log -1 --pretty=%s)" \
            --body "Automated PR from CI" \
            --draft
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### With Code Review Tools

Integrate with code quality tools:

```bash
# Run checks before creating PR
npm run lint
npm run test
npm run build

# If all pass, create PR
if [ $? -eq 0 ]; then
  gh pr create --title "..." --body "..."
else
  echo "❌ Checks failed. Fix issues before creating PR."
  exit 1
fi
```

## Troubleshooting

### Problem: PR Already Exists Error

**Error message**:
```
GraphQL: A pull request already exists for username:branch-name
```

**Solution**:
```bash
# View existing PR
gh pr view

# Update existing PR instead
gh pr edit --title "New title" --body "Updated description"
```

### Problem: Authentication Failed

**Error message**:
```
error: authentication required
```

**Solution**:
```bash
# Re-authenticate with GitHub
gh auth login

# Check authentication status
gh auth status

# Use different account if needed
gh auth login --hostname github.com
```

### Problem: Branch Not Found on Remote

**Error message**:
```
error: branch 'feature/new-feature' not found on remote
```

**Solution**:
```bash
# Push branch to remote first
git push -u origin feature/new-feature

# Then create PR
gh pr create
```

### Problem: No Commits to Create PR

**Error message**:
```
error: no commits between base and head
```

**Solution**:
```bash
# Verify you have commits
git log main...HEAD

# If empty, make changes and commit first
git add .
git commit -m "Add changes"
git push
```

### Problem: Merge Conflicts

**Warning**:
```
⚠️ This branch has conflicts with the base branch
```

**Solution**:
```bash
# Update your branch with latest base
git fetch origin
git merge origin/main  # or origin/develop

# Resolve conflicts
git status
# [resolve conflicts in files]
git add .
git commit -m "Resolve merge conflicts"
git push

# PR will auto-update
```

### Problem: Failed CI Checks

**Issue**: PR created but CI checks are failing

**Solution**:
```bash
# View check results
gh pr checks

# View detailed logs
gh pr checks --watch

# Fix issues locally
# [make fixes]
git add .
git commit -m "Fix CI issues"
git push

# Checks will re-run automatically
```

### Problem: Template Not Found

**Issue**: PR template exists but not being used

**Solution**:
```bash
# Check template location (must be in one of these paths)
ls .github/pull_request_template.md
ls .github/PULL_REQUEST_TEMPLATE.md
ls docs/pull_request_template.md

# Read template and use it manually
cat .github/pull_request_template.md

# Create PR with template content
gh pr create --body "$(cat .github/pull_request_template.md)"
```

### Problem: Permission Denied

**Error message**:
```
error: permission denied to create pull request
```

**Solution**:
```bash
# For forked repositories, ensure you're creating PR correctly
gh pr create \
  --repo upstream-owner/repo-name \
  --head your-username:branch-name \
  --base main

# Check repository permissions
gh repo view --web
```

## Performance Considerations

1. **Parallel operations**: Run git status, branch checks, and fetch concurrently
2. **Efficient commit analysis**: Use `--oneline` and `--stat` for faster analysis
3. **Stream content**: Use HEREDOC to pass PR body directly (no temp files)
4. **Cache branch info**: Remember detected base branch to avoid re-detection
5. **Lazy template loading**: Only read PR template if it exists

## Security Considerations

**Never include in PRs**:
- API keys, tokens, passwords
- Private keys or certificates
- Database credentials
- Internal URLs or endpoints

**Pre-PR security checks**:
```bash
# Check for secrets before creating PR
git secrets --scan

# Or use gitleaks
gitleaks detect --source .

# Verify no sensitive files are included
git diff --name-only main...HEAD | grep -E '\.(env|pem|key)$'
```

**Security-sensitive file warnings**:
- `.env` files
- `credentials.json`
- `*.pem`, `*.key` files
- `secrets.yml`

## GitHub CLI Command Reference

### PR Creation Commands

```bash
# Create PR (interactive mode)
gh pr create

# Create PR with title and body
gh pr create --title "Title" --body "Description"

# Create PR with HEREDOC body
gh pr create --title "Title" --body "$(cat <<'EOF'
Multi-line
description
EOF
)"

# Create draft PR
gh pr create --draft

# Create PR with specific base
gh pr create --base develop

# Create PR with reviewers
gh pr create --reviewer @alice,@bob

# Create PR with assignees
gh pr create --assignee @me

# Create PR with labels
gh pr create --label bug,priority-high

# Create PR in different repo (for forks)
gh pr create --repo owner/repo --head user:branch
```

### PR Management Commands

```bash
# View current branch's PR
gh pr view

# View PR in browser
gh pr view --web

# View specific PR
gh pr view 123

# Edit PR title and description
gh pr edit --title "New title" --body "New description"

# Edit PR to add reviewers
gh pr edit --add-reviewer @alice

# Edit PR to add labels
gh pr edit --add-label bug

# Mark draft as ready
gh pr ready

# Convert to draft
gh pr ready --undo

# Add comment to PR
gh pr comment --body "Comment text"

# View PR checks
gh pr checks

# Watch PR checks
gh pr checks --watch

# Merge PR
gh pr merge

# Merge with squash
gh pr merge --squash

# Merge with rebase
gh pr merge --rebase

# Auto-merge when checks pass
gh pr merge --auto --squash

# Close PR
gh pr close

# Reopen PR
gh pr reopen

# List all PRs
gh pr list

# List PRs with specific label
gh pr list --label bug

# List PRs by author
gh pr list --author @me
```

## Quick Reference

```bash
# === Basic PR Creation ===
# Create PR (interactive)
gh pr create

# Create PR with details
gh pr create --title "feat: add feature" --body "Description"

# Create draft PR
gh pr create --draft

# === PR with Options ===
# PR with base branch
gh pr create --base develop

# PR with reviewers and labels
gh pr create --reviewer @alice --label bug,priority-high

# === Update Existing PR ===
# View PR
gh pr view

# Update PR description
gh pr edit --title "New title" --body "New description"

# === PR Checks and Status ===
# View checks
gh pr checks

# Watch checks
gh pr checks --watch

# === Merge PR ===
# Merge with squash
gh pr merge --squash

# Auto-merge when ready
gh pr merge --auto --squash

# === Analyze Before Creating ===
# Check status
git status

# View commits
git log --oneline main...HEAD

# View changes
git diff --stat main...HEAD
```

## Resources

- GitHub CLI docs: https://cli.github.com/manual/
- PR best practices: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests
- Conventional commits: https://www.conventionalcommits.org/
- Git Flow: https://nvie.com/posts/a-successful-git-branching-model/
