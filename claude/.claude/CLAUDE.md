# Claude Code Guidelines

## Tool Usage

Always use these Claude Code tools proactively:
- **EnterPlanMode** - Use before non-trivial implementations
- **Task** - Use for complex multi-step tasks and codebase exploration
- **TodoWrite** - Use to track and plan all tasks
- **AskUserQuestion** - Use when clarification needed

## Available CLI Tools

`jq` `gh` `fd` `ast-grep` `rg` `curl` `kubectl` `docker` `aws` `gcloud` `terraform` `helm` `mongosh` `mysql` `sqlite3` `node` `npm` `bun` `python3` `go` `make` `act` `cfn-lint` `checkov` `openssl`

## Workspace Structure

Projects are stored in `$HOME/developer/` using git worktrees:

```
{project}/
├── main/          # main branch
└── worktree/
    └── {branch}/  # feature branches
```
