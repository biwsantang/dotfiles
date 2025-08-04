# Claude Command: Create PR

This command helps you create well-formatted pull requests using the GitHub CLI.

## Usage

To create a pull request, just type:
```
/create-pr
```

Or with options:
```
/create-pr --draft
/create-pr --base develop
```

## What This Command Does

1. Fetches latest changes from origin with `git fetch origin`
2. Checks the current git status to verify there are no uncommitted changes
3. If there are uncommitted changes, tells the user to commit them first
4. Verifies the current branch is pushed to remote (pushes if needed)
5. Intelligently determines the appropriate base branch:
   - Feature branches → `develop` (if it exists) or `main`
   - `develop` branch → `main`
   - Other branches → `main` (unless specified)
6. Analyzes the commit diff from the determined base branch
7. Creates a comprehensive PR summary based on all commits and changes
8. Writes the PR body to a temporary file
9. Uses `gh pr create --body-file` to create the pull request with the generated description

## Best Practices for Pull Requests

- **Clear title**: Use descriptive titles that summarize the main change
- **Comprehensive summary**: Include 1-3 bullet points explaining what was changed
- **Test plan**: Provide clear steps for reviewers to test the changes
- **Atomic PRs**: Keep PRs focused on a single feature or fix when possible
- **Smart base branch detection**: The command automatically detects the appropriate target branch

## Pull Request Structure

The command creates PRs using this priority:

1. **If `.github/pull_request_template.md` exists**: Uses the template structure and fills in relevant sections
2. **If no template exists**: Uses the default format below:

**Title**: Brief description of the main change
**Body**:
```
## Summary
- Bullet point 1: Key change description
- Bullet point 2: Additional important change
- Bullet point 3: Other notable modifications

## Test plan
[Checklist of steps for testing the pull request]

🤖 Generated with [Claude Code](https://claude.ai/code)
```

## Examples

Good PR titles:
- feat: add user authentication system
- fix: resolve memory leak in rendering process
- docs: update API documentation with new endpoints
- refactor: simplify error handling logic in parser
- chore: update dependencies to latest versions

Good PR summaries:
- Add OAuth integration with Google and GitHub providers
- Fix race condition causing intermittent test failures
- Refactor database connection pooling for better performance
- Update React components to use new design system tokens

## Base Branch Detection Logic

The command automatically determines the target base branch:

- **Feature branches** (e.g., `feature/auth`, `fix/bug-123`): Target `develop` if it exists, otherwise `main`
- **develop branch**: Target `main`
- **Other branches**: Target `main` unless `--base` is specified
- **Override**: Use `--base <branch>` to specify a different target

## Implementation Details

- Fetches origin to ensure up-to-date comparison with base branch
- Checks for existing PR template at `.github/pull_request_template.md`
- Uses `git diff <base-branch>...` to analyze all changes in the current branch compared to the target base branch
- If PR template exists, uses it as the structure and fills in the relevant sections
- If no template exists, generates PR body using the default structure below
- Writes the PR body content to a temporary file
- Uses `gh pr create --title "<generated-title>" --body-file <temp-file>` for proper formatting and special characters
- Cleans up temporary file after PR creation

## Important Notes

- **Prerequisites**: All changes must be committed and pushed before creating a PR
- If there are uncommitted changes, the command will stop and ask you to commit them first
- If the branch isn't pushed to remote, it will push with the `-u` flag
- Always fetches origin first to ensure base branch comparison is current
- The command analyzes ALL commits in the current branch since it diverged from the base branch
- Smart base branch detection follows common Git Flow patterns
- The PR description includes both a summary of changes and a test plan
- Always reviews the full commit history to ensure the PR description is comprehensive
- Uses conventional commit prefixes in the title when appropriate
- Automatically adds the Claude Code attribution footer