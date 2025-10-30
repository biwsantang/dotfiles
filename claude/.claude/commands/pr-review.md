---
description: Review pull requests with intelligent analysis and line-level commenting
argument-hint: "[PR number/URL]"
allowed-tools: Bash(gh *), Bash(git *)
---

# PR Review Command

## Context

- PR metadata: !`gh pr view ${ARGUMENTS:-} --json number,title,body,headRefName,baseRefName,state,isDraft,author,url,files,commits,reviews 2>/dev/null || echo "PR_NOT_FOUND"`
- PR diff: !`gh pr diff ${ARGUMENTS:-} 2>/dev/null || echo "DIFF_FAILED"`
- Repository root: !`git rev-parse --show-toplevel 2>/dev/null`
- Current branch: !`git branch --show-current 2>/dev/null`

You are performing a comprehensive code review of a GitHub pull request. The bash commands above have gathered:

1. **PR metadata**: Number, title, description, author, state (draft/ready), base/head branches, files changed, commits, and existing reviews
2. **PR diff**: Full diff of all changes in the PR
3. **Repository root**: The absolute path to the git repository
4. **Current branch**: The branch you're currently on

### PR Detection Logic

- If `$ARGUMENTS` contains a PR number (e.g., "123") → use that specific PR
- If `$ARGUMENTS` contains a URL (e.g., "https://github.com/owner/repo/pull/123") → use that PR
- If `$ARGUMENTS` is empty → find the open PR for the current branch
- If PR is not found → inform the user and suggest creating one

### Jira Integration

Automatically detect and fetch Jira ticket information for context-aware reviews:

1. **Extract Jira ticket ID** from PR title, branch name, or description (format: PROJ-123, ABC-456, etc.)
2. **Fetch ticket details** using available Jira MCP tools (`mcp__jira__*`)
3. **Incorporate context** including requirements, acceptance criteria, and ticket description into the review

### Existing Reviews Consideration

- **Check existing reviews** from the PR metadata to avoid duplicating feedback
- **Acknowledge previous comments** and focus on new issues or areas not yet addressed
- **Build upon feedback** rather than repeating what others have already mentioned

## Your task

Perform a comprehensive PR review following this structure:

### 1. Analyze PR Context

- **Purpose**: Understand what the PR is trying to accomplish from title and description
- **Jira ticket** (if found): Review requirements, acceptance criteria, and acceptance of done
- **Scope**: Identify the files and areas being modified
- **Existing feedback**: Note issues already identified in previous reviews

### 2. Review Code Changes

Perform detailed analysis across these areas:

**Code Quality**
- Style consistency and naming conventions
- Best practices for the language/framework used
- Code complexity and maintainability
- Documentation and comments adequacy

**Security**
- Common vulnerability patterns (SQL injection, XSS, CSRF, etc.)
- Input validation and sanitization
- Authentication and authorization checks
- Hardcoded secrets or sensitive data exposure

**Performance**
- Potential bottlenecks or inefficient algorithms
- Database query optimization and N+1 problems
- Resource usage (memory, CPU)
- Caching opportunities

**Architecture & Design**
- Appropriate use of design patterns
- Separation of concerns and modularity
- Dependency management
- API design principles

**Requirements Validation** (if Jira ticket found)
- All acceptance criteria addressed
- Implementation aligns with ticket requirements
- Scope is appropriate (not missing or exceeding requirements)
- Related dependencies or linked issues considered

### 3. Generate Review Summary

Create a comprehensive review in markdown format:

```markdown
## 🔍 Code Review Summary

### 🎫 Jira Context
[Only include if Jira ticket was found]
- **Ticket**: [PROJ-123: Ticket Title]
- **Requirements Met**: [✅ All met / ⚠️ Partially met / ❌ Not met]
- **Acceptance Criteria**: [List each criterion with status]

### ✅ Strengths
[Highlight positive aspects - good patterns, clean code, etc.]

### ⚠️ Issues Found
[List issues with specific file paths and line references]

### 💡 Suggestions
[Provide improvement recommendations with examples]

### 🛡️ Security Considerations
[Include only if security concerns were identified]

---
*Review generated with [Claude Code](https://claude.ai/code)*
```

### 4. Ask About Submitting Review

After presenting your analysis, ask the user:

**Question**: "Would you like me to submit this review to GitHub?"

**Options**:
- **APPROVE**: Approve the PR (use when code looks good with only minor suggestions)
- **REQUEST_CHANGES**: Request changes before merging (use when issues need to be fixed)
- **COMMENT**: Add comments without approval/rejection (use for informational feedback)
- **Don't submit**: Just show the review summary without posting to GitHub

### 5. Submit Review (if approved)

If the user wants to submit the review, use the GitHub API:

```bash
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/OWNER/REPO/pulls/PR_NUMBER/reviews \
  --input - <<< '{
  "commit_id": "LATEST_COMMIT_SHA",
  "body": "Your comprehensive review summary",
  "event": "APPROVE|REQUEST_CHANGES|COMMENT",
  "comments": [
    {
      "path": "path/to/file.js",
      "position": 15,
      "body": "Specific comment about this line"
    }
  ]
}'
```

**Important**:
- Extract OWNER, REPO, and PR_NUMBER from the PR metadata
- Use the latest commit SHA from the commits list
- The `position` field is the line position in the diff (not file line number)
- Only include `comments` array if you have specific line-level feedback
- Calculate diff positions by parsing `gh pr diff` output

## Guidelines

- **Be constructive**: Focus on improvements, not just problems
- **Be specific**: Provide concrete examples and alternative approaches
- **Be contextual**: Consider the PR's purpose and scope
- **Avoid duplication**: Don't repeat feedback from existing reviews
- **Prioritize issues**: Security and correctness over style preferences
- **Use examples**: Show better alternatives when suggesting changes

## Examples of Good Review Comments

- "Consider extracting this complex logic into a separate utility function for better testability"
- "This database query could benefit from an index on the `user_id` column to improve performance"
- "The input validation should include sanitization to prevent XSS attacks"
- "Great use of the strategy pattern here - makes the code very extensible"

## File Type Specific Focus

- **JavaScript/TypeScript**: Type safety, async handling, React patterns, bundle size
- **Python**: PEP 8 compliance, error handling, type hints, performance patterns
- **Go**: Error handling, goroutine safety, interface usage, defer patterns
- **SQL**: Query optimization, injection prevention, indexing strategies
- **CSS**: Responsive design, accessibility, performance, browser compatibility
- **Markdown**: Formatting, link validity, code block syntax
