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
