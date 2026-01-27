# Claude Code Guidelines

## Tool Usage

Always use these Claude Code tools proactively:
- **EnterPlanMode** - Use before non-trivial implementations
- **Task** - Use for complex multi-step tasks and codebase exploration
- **TodoWrite** - Use to track and plan all tasks
- **AskUserQuestion** - Use when clarification needed

## Available CLI Tools

### JSON & Search
- **jq** - JSON processor
  - Parse API responses: `curl api | jq '.data[]'`
  - Transform JSON configs

- **rg** - ripgrep, fast code search
  - Find patterns: `rg "TODO" --type ts`
  - Search large codebases

- **fd** - fast find alternative
  - Find files: `fd "\.tsx$"`
  - Simpler syntax than find

- **ast-grep** - AST-based search/refactor
  - Find code patterns: `ast-grep -p 'console.log($$$)'`
  - Structural code changes

### GitHub & Cloud
- **gh** - GitHub CLI
  - PR management: `gh pr create`
  - Actions: `gh run list`

- **aws** - AWS CLI
  - S3 operations: `aws s3 cp`
  - Lambda, ECS, CloudWatch

- **gcloud** - Google Cloud CLI
  - GCS, Cloud Run, GKE operations

- **kubectl** - Kubernetes
  - Deployments: `kubectl apply -f`
  - Logs: `kubectl logs -f pod`

## Common Mistakes

### Parallel commands with `cd`
Parallel Bash calls each run in **separate shell contexts**, so `cd` fails independently in each.

**Wrong:**
```bash
# These run in parallel - each cd fails separately
cd project && npm install
cd project && npm test
```

**Correct:**
```bash
# Use absolute paths for parallel execution
npm install --prefix /path/to/project
npm test --prefix /path/to/project

# Or chain sequentially if cd is required
cd project && npm install && npm test
```

## Workspace Structure

Projects are stored in `$HOME/developer/` using git worktrees:

```
{project}/
├── main/          # main branch
└── worktree/
    └── {branch}/  # feature branches
```
