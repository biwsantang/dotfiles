# Claude Code Guidelines

## Available CLI Tools

These tools are installed and available:
- **jq** - JSON processor
- **rg** - ripgrep (fast code search)
- **fd** - fast find alternative
- **ast-grep** - AST-based search/refactor
- **gh** - GitHub CLI
- **aws** - AWS CLI
- **gcloud** - Google Cloud CLI
- **kubectl** - Kubernetes CLI

## Common Mistakes

### Parallel commands with `cd`

Parallel Bash calls run in **separate shell contexts**, so `cd` fails independently.

**Wrong:**
```bash
cd project && npm install
cd project && npm test
```

**Correct:**
```bash
npm install --prefix /path/to/project
npm test --prefix /path/to/project
# Or chain sequentially
cd project && npm install && npm test
```

## Workspace Layout

Projects live at `~/Developer/projects/{org}/{repo}`. Each repo uses a bare clone (`.git/`) with worktrees as siblings:

```
~/Developer/projects/
├── scbabacus/              # github org
│   └── l2020-backend/
│       ├── .git/           # bare clone
│       ├── main/           # worktree
│       ├── develop/        # worktree
│       └── feat/
│           └── PLAT-123-add-login/
├── local/                  # local org (no remote)
│   └── my-project/
│       ├── .git/
│       └── main/
└── {future-org}/
```

## Always-On Git Rules

These rules apply to **every** git operation, regardless of which skill is active:

- Before destructive git operations (reset, rebase, force-push), run `pwd && git branch --show-current` to verify context — but do NOT cd or verify for routine commands (build, test, install, status, diff, log)
- Use `git worktree add` to switch branches — never `git checkout` or `git switch` (checkout detaches a worktree from its branch)
- Worktree paths must be siblings to `.git/`, not subdirectories
- If a branch already has a worktree, `cd` to the existing worktree instead of creating a new one
- Never commit directly to `main` or `develop` — always create a feature branch first
- If the user asks to commit to `main`/`develop`, warn them and suggest creating a branch
- Use `--force-with-lease` for force pushes, never `--force` (prevents overwriting others' work)
- Never force push to `main` or `develop` unless the user explicitly asks

## Org Registry

| Org | Type | Remote | Branch Format | Clone Command |
|-----|------|--------|---------------|---------------|
| scbabacus | github | `scbabacus` | `{prefix}/PLAT-{ticket}-{desc}` | `gh repo clone scbabacus/$REPO .git -- --bare` |
| local | local | none | `{prefix}/{desc}` | `git init --bare .git` |

**Defaults:**

| Action | Default | Override |
|--------|---------|----------|
| Branch base | `develop` | `main` if no develop, `hotfix/` always from `main` |
| PR target | `develop` | `main` if no develop, `hotfix/` always to `main` |

**Protected Branches:**

| Branch | Direct Commit | Force Push |
|--------|---------------|------------|
| `main` | Never | Never |
| `develop` | Never | Never |
| `feat/*`, `fix/*`, etc. | Yes | With `--force-with-lease` only |
