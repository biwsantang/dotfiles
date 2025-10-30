---
description: Create or update a pull request
argument-hint: [optional: describe what this PR does or specify draft/base branch]
model: claude-haiku-4-5-20251001
allowed-tools: Bash(git *), Bash(gh *)
---

## Context

- Current git status: !`git status`
- Branch status with tracking info: !`git branch -vv`
- Recent commits: !`git log --oneline -10`
- Remote repositories: !`git remote -v`
- The user wants to create or update a pull request. Arguments provided: $ARGUMENTS

## Your task

Follow the Pull Request Creator skill workflow to create or update a well-formatted pull request:

1. **Validate prerequisites** (run in parallel):
   - Check git status for uncommitted changes - if any exist, stop and ask user to commit first
   - Check if branch is pushed to remote - if not, push with `git push -u origin <branch>`
   - Fetch latest changes: `git fetch origin`

2. **Determine base branch** using smart detection:
   - Feature/fix branches → `develop` (if exists), else `main`
   - Develop branch → `main`
   - Hotfix branches → `main`
   - Override if user specified `--base <branch>` in $ARGUMENTS

3. **Analyze ALL commits** since branch divergence:
   ```bash
   git log --oneline <base-branch>...HEAD
   git diff --stat <base-branch>...HEAD
   git diff <base-branch>...HEAD
   ```

4. **Check for PR template**: Look for `.github/pull_request_template.md` and use it if available

5. **Check if PR exists** for current branch:
   ```bash
   gh pr view
   ```

6. **Create or update PR**:
   - If no PR exists: Use `gh pr create` with HEREDOC for body
   - If PR exists: Use `gh pr edit` to update title and body
   - Generate comprehensive title and description based on ALL commits (not just latest)
   - Include conventional commit style in title when appropriate
   - Add Claude Code attribution to body

7. **Handle user-provided flags** from $ARGUMENTS:
   - `--draft`: Create as draft PR
   - `--base <branch>`: Override base branch
   - `--reviewer <users>`: Request reviewers
   - `--assignee <users>`: Assign users
   - `--label <labels>`: Add labels

8. **Return PR URL** to user when complete

**Important**:
- Analyze ALL commits in the branch, not just the most recent one
- Use parallel bash operations where possible for performance
- Handle existing PRs gracefully by updating instead of failing
- Use HEREDOC format for PR body to ensure proper formatting
