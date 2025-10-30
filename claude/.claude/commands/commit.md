---
description: Create a git commit
argument-hint: [optional context about what you changed]
allowed-tools: Bash(git *)
---

## Context

- Current git status: !`git status`
- Staged changes: !`git diff --staged`
- Unstaged changes: !`git diff`
- Recent commits: !`git log -5 --oneline --decorate`
- Optional user context: $ARGUMENTS

## Your task

You are the Git Commit Helper. Create well-formatted conventional commits with intelligent change analysis.

### Step 1: Analyze Changes

Based on the git context above, analyze:
1. What files have changed (staged and unstaged)
2. The nature of the changes (new features, bug fixes, documentation, etc.)
3. Whether changes should be split into multiple atomic commits or combined into one

**Single commit if**:
- All changes relate to one purpose
- Changes are tightly coupled
- Total diff is reasonably sized

**Split commits if**:
- Different functionality (features vs bug fixes vs refactoring vs docs)
- Different subsystems (auth vs API vs UI vs config)
- Different file types that serve different purposes
- Implementation vs tests vs dependencies

### Step 2: Security Check

Before staging, verify no sensitive files are being committed:
- `.env*`, `credentials.json`, `secrets.json`, `*.pem`, `*.key`, `*.p12`, `*.pfx`
- API tokens, passwords, private keys

If secrets detected, WARN the user and only proceed if explicitly confirmed.

### Step 3: Stage Files

If files are not yet staged, stage them appropriately:
- For single commit: `git add .` (excluding secrets)
- For split commits: Stage files selectively using `git add path/to/file1 path/to/file2` or patterns

### Step 4: Create Commit(s)

Generate conventional commit messages following this format:

```bash
git commit -m "$(cat <<'EOF'
<type>[optional scope]: <description>

[optional body explaining why, not what]

[optional footer: Fixes #123]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**Commit types**:
- `feat` - A new feature
- `fix` - A bug fix
- `docs` - Documentation only changes
- `style` - Code style changes (formatting, semicolons, etc.)
- `refactor` - Code change that neither fixes a bug nor adds a feature
- `perf` - Performance improvement
- `test` - Adding or correcting tests
- `build` - Build system or external dependencies
- `ci` - CI configuration files and scripts
- `chore` - Other changes that don't modify src or test files
- `revert` - Reverts a previous commit

**Commit message rules**:
- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize first letter
- No period at the end
- Keep under 72 characters
- Be specific and meaningful

**Consider user context**: If $ARGUMENTS is provided, incorporate it into the commit message.

### Step 5: Handle Pre-commit Hooks

If commit fails due to pre-commit hooks:
1. Read the error message carefully
2. Fix issues identified by hooks
3. If hooks modified files:
   - Check authorship: `git log -1 --format='%an %ae'`
   - Check not pushed: `git status` shows "Your branch is ahead"
   - If both true: amend with `git add . && git commit --amend --no-edit`
   - Otherwise: create new commit with message "chore: apply pre-commit hook fixes"
4. Retry the commit

**Bypass hooks**: Only if user explicitly passed `--no-verify` in $ARGUMENTS, add that flag to the commit command.

### Step 6: Verify Success

After committing, run:
```bash
git status && git log -1
```

Confirm the commit was created successfully and summarize what was committed.

### Best Practices

1. Each commit should represent one logical change (atomic commits)
2. Write clear, descriptive messages that explain "why" not "what"
3. Don't mix unrelated changes
4. Use conventional format for parseable history
5. Reference issue tracker when relevant (Fixes #123, Closes #456)

### Performance

Run independent git commands in parallel when gathering information:
```bash
git status & git diff --staged & git diff & wait
```
