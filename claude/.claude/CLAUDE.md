# Claude Code Skills

Custom skills for enhanced development workflows.

## Available Skills

### AST-Grep Code Search
**Trigger**: `ast-grep`, structural search, code pattern matching

Performs structural code search and refactoring using Abstract Syntax Tree patterns.

**Need to use when**:
- Searching for code patterns across multiple lines
- Performing structural refactoring
- Finding language constructs (functions, classes, expressions)
- Replacing code patterns while preserving formatting

**Example**:
```bash
ast-grep --pattern 'console.log($$$)' --lang js
ast-grep --pattern 'useEffect($$$)' --rewrite 'useLayoutEffect($$$)' --lang tsx --update-all
```

### Terminal Pane & Tab Management
**Trigger**: `new pane`, `new tab`, `split terminal`, `spawn instance`

Manages Zellij terminal multiplexer panes and tabs for multi-instance workflows.

**Need to use when**:
- Spawning multiple Claude Code instances
- Running commands in separate visible panes
- Organizing tasks (dev server, tests, logs) in one view
- Creating development layouts

**Example**:
```bash
zellij action new-pane --direction right
zellij run --direction down -- npm test
zellij action new-tab
```

## Usage

Skills are automatically activated when Claude Code detects relevant keywords in your requests, or you need to explicitly reference them.

**Location**: `.claude/skills/`
