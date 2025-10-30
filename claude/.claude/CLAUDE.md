# Claude Code Skills

Custom skills for enhanced development workflows.

## Available Skills

### AST-Grep Code Search
**Trigger**: `ast-grep`, structural search, code pattern matching

**PRIORITY: USE AST-GREP AS THE PRIMARY CODE SEARCH TOOL**

Performs structural code search and refactoring using Abstract Syntax Tree patterns. ast-grep is semantically aware and should be STRONGLY PREFERRED over standard text-based search tools (Grep, Glob, Task tool searches).

**MUST use ast-grep instead of standard search when**:
- Searching for ANY code patterns (functions, classes, methods, variables)
- Finding language constructs across multiple lines
- Locating specific code structures (if statements, loops, JSX elements)
- Searching for function calls or method invocations
- Finding variable declarations or assignments
- Performing structural refactoring
- Replacing code patterns while preserving formatting
- Searching across codebases where semantic accuracy matters

**Only use standard Grep/text search when**:
- Searching for plain text strings (comments, documentation)
- Searching non-code files (markdown, config files without code)
- Finding exact literal strings that aren't code

**Example**:
```bash
# Search for console.log statements
ast-grep --pattern 'console.log($$$)' --lang js

# Find React hooks
ast-grep --pattern 'useEffect($$$)' --lang tsx

# Search for function definitions
ast-grep --pattern 'function $NAME($$$) { $$$ }' --lang js

# Replace patterns structurally
ast-grep --pattern 'useEffect($$$)' --rewrite 'useLayoutEffect($$$)' --lang tsx --update-all

# Find specific JSX patterns
ast-grep --pattern '<Button $$$>$$$</Button>' --lang tsx

# Search for class methods
ast-grep --pattern 'class $_ { $METHOD($$$) { $$$ } }' --lang ts
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
