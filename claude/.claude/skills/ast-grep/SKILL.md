---
name: AST-Grep Code Search
description: Performs structural code search and refactoring using AST-based patterns. Use when searching for code patterns, refactoring code structurally, finding function calls, class definitions, or when the user mentions "ast-grep", "structural search", "code pattern", or needs to find/replace code that's difficult with regex.
---

# AST-Grep Code Search

Helps perform structural code search and automated refactoring using Abstract Syntax Tree (AST) patterns. Unlike grep/regex which work on text, ast-grep understands code structure and can match patterns across multiple lines while ignoring formatting differences.

## Core Responsibilities

1. **Structural pattern matching** - Find code patterns based on AST structure, not text
2. **Language-aware search** - Understands syntax for multiple languages (JS, TS, Python, Rust, Go, etc.)
3. **Smart refactoring** - Replace code patterns while preserving formatting and semantics
4. **Cross-file operations** - Search and replace across entire codebases
5. **Metavariable capture** - Capture and reuse parts of matched patterns

## When to Use AST-Grep vs Regular Grep

**Use AST-Grep when**:
- Searching for code patterns that span multiple lines
- Formatting/whitespace differences should be ignored
- Need to match specific language constructs (functions, classes, expressions)
- Performing structural refactoring or code transformations
- Finding patterns that are difficult to express with regex

**Use Regular Grep when**:
- Simple string/regex search is sufficient
- Searching for text in non-code files
- Performance is critical for very large codebases

## Installation Check

Before using ast-grep, verify it's installed:
```bash
# Check if ast-grep is available
which ast-grep || echo "ast-grep not installed"
```

If not installed, guide the user to install it:
```bash
# Install via cargo (Rust)
cargo install ast-grep

# Or via npm
npm install -g @ast-grep/cli

# Or via homebrew (macOS)
brew install ast-grep
```

## Basic Usage Patterns

### Pattern 1: Simple Search

Search for a code pattern in the current directory:

```bash
# Find all console.log statements
ast-grep --pattern 'console.log($$$)' --lang js

# Find function definitions
ast-grep --pattern 'function $NAME($$$) { $$$ }' --lang js

# Find React useEffect hooks
ast-grep --pattern 'useEffect($$$)' --lang tsx
```

### Pattern 2: Search with Context

Show surrounding lines for better understanding:

```bash
# Show 3 lines of context before and after matches
ast-grep --pattern 'console.log($$$)' --lang js -C 3

# Show only 2 lines after
ast-grep --pattern 'console.log($$$)' --lang js -A 2
```

### Pattern 3: Search and Replace

Perform structural refactoring across files:

```bash
# Replace console.log with logger.debug (dry-run)
ast-grep --pattern 'console.log($$$ARGS)' \
  --rewrite 'logger.debug($$$ARGS)' \
  --lang js

# Apply changes (use --update-all or interactive mode)
ast-grep --pattern 'console.log($$$ARGS)' \
  --rewrite 'logger.debug($$$ARGS)' \
  --lang js \
  --update-all
```

### Pattern 4: Language-Specific Search

Different languages require different patterns:

```bash
# Python: Find all class definitions
ast-grep --pattern 'class $NAME: $$$' --lang python

# Rust: Find all impl blocks
ast-grep --pattern 'impl $$$' --lang rust

# Go: Find all struct definitions
ast-grep --pattern 'type $NAME struct { $$$ }' --lang go

# TypeScript: Find all interface definitions
ast-grep --pattern 'interface $NAME { $$$ }' --lang typescript
```

### Pattern 5: Complex Patterns with Constraints

Use YAML configuration for complex searches:

Create a temporary config file or use inline YAML:

```yaml
# pattern-config.yml
rule:
  pattern: console.log($MSG)
  kind: call_expression
constraints:
  MSG:
    regex: "error|warning|debug"
```

```bash
ast-grep scan --config pattern-config.yml
```

## Metavariable Syntax

AST-grep uses special metavariables to capture parts of code:

- `$VAR` - Captures a single AST node (variable, expression, etc.)
- `$$` - Captures multiple statements/nodes (not commonly used alone)
- `$$$` - Captures zero or more nodes (useful for variable arguments)
- `$_` - Matches anything but doesn't capture

**Examples**:
```bash
# Capture function name and arguments
ast-grep --pattern 'function $NAME($$$ARGS) { $$$BODY }' --lang js

# Capture object property
ast-grep --pattern '$OBJ.$PROP()' --lang js

# Capture if condition
ast-grep --pattern 'if ($COND) { $$$THEN }' --lang js
```

## Common Use Cases

### Use Case 1: Find All TODO Comments

```bash
# Find TODO comments in code
ast-grep --pattern '// TODO: $$$' --lang js
ast-grep --pattern '# TODO: $$$' --lang python
```

### Use Case 2: Refactor API Calls

```bash
# Change fetch to axios
ast-grep --pattern 'fetch($URL)' \
  --rewrite 'axios.get($URL)' \
  --lang js \
  --update-all
```

### Use Case 3: Find Security Vulnerabilities

```bash
# Find dangerous eval usage
ast-grep --pattern 'eval($$$)' --lang js

# Find SQL string concatenation (potential injection)
ast-grep --pattern '"SELECT * FROM " + $$$' --lang js
```

### Use Case 4: Find Unused Imports

```bash
# Find specific import statements
ast-grep --pattern 'import { $$$NAMES } from "$MODULE"' --lang js
```

### Use Case 5: Modernize Code

```bash
# Convert var to const
ast-grep --pattern 'var $NAME = $$$' \
  --rewrite 'const $NAME = $$$' \
  --lang js \
  --update-all

# Convert class components to functional (more complex, may need manual review)
ast-grep --pattern 'class $NAME extends React.Component { $$$ }' --lang jsx
```

## Workflow for Complex Refactoring

### Step 1: Search and Verify Pattern

First, verify the pattern matches what you expect:

```bash
# Search without replacing
ast-grep --pattern '<your-pattern>' --lang <language>
```

Review the matches to ensure they're correct.

### Step 2: Test Rewrite (Dry Run)

See what the replacement would look like:

```bash
# Show what would change (dry run)
ast-grep --pattern '<pattern>' \
  --rewrite '<replacement>' \
  --lang <language>
```

### Step 3: Interactive Update

Use interactive mode to review each change:

```bash
# Interactive mode - review each change
ast-grep --pattern '<pattern>' \
  --rewrite '<replacement>' \
  --lang <language> \
  --interactive
```

### Step 4: Bulk Update (if confident)

Apply all changes at once:

```bash
# Apply all changes
ast-grep --pattern '<pattern>' \
  --rewrite '<replacement>' \
  --lang <language> \
  --update-all
```

### Step 5: Verify Changes

After refactoring, verify the changes:

```bash
# Check git diff
git diff

# Run tests
npm test  # or appropriate test command

# Check linting
npm run lint  # or appropriate lint command
```

## Language Support

AST-grep supports many languages. Specify with `--lang`:

- **JavaScript**: `js`, `javascript`
- **TypeScript**: `ts`, `typescript`, `tsx`
- **Python**: `py`, `python`
- **Rust**: `rs`, `rust`
- **Go**: `go`, `golang`
- **Java**: `java`
- **C/C++**: `c`, `cpp`, `cxx`
- **C#**: `cs`, `csharp`
- **Ruby**: `rb`, `ruby`
- **HTML**: `html`
- **CSS**: `css`
- **JSON**: `json`

## Output Formats

Control output format for integration with other tools:

```bash
# Default colored output (human-readable)
ast-grep --pattern 'console.log($$$)' --lang js

# JSON output (machine-readable)
ast-grep --pattern 'console.log($$$)' --lang js --json

# Compact output
ast-grep --pattern 'console.log($$$)' --lang js --compact
```

## File Filtering

Control which files to search:

```bash
# Search specific file
ast-grep --pattern 'console.log($$$)' --lang js src/main.js

# Search specific directory
ast-grep --pattern 'console.log($$$)' --lang js src/

# Use glob pattern (via find)
find src -name "*.test.js" -exec ast-grep --pattern 'describe($$$)' --lang js {} +
```

## Advanced: Rule Configuration Files

For complex searches, create YAML configuration files:

**Example: `.ast-grep/rules/no-console.yml`**
```yaml
id: no-console-log
language: TypeScript
rule:
  pattern: console.log($$$)
message: "Avoid using console.log in production code"
severity: warning
fix:
  pattern: console.log($$$ARGS)
  rewrite: logger.debug($$$ARGS)
```

Then scan with:
```bash
ast-grep scan
```

## Performance Considerations

1. **File filtering**: Use specific paths or glob patterns to reduce search scope
2. **Language specification**: Always specify `--lang` for better performance
3. **Parallel processing**: ast-grep automatically uses multiple cores
4. **Cache**: Results are cached during interactive sessions

## Best Practices

1. **Start simple**: Begin with simple patterns and iterate
2. **Test patterns**: Always dry-run before applying changes
3. **Use git**: Ensure code is committed before bulk refactoring
4. **Review changes**: Use `git diff` to review all changes before committing
5. **Run tests**: Always run tests after refactoring
6. **Incremental refactoring**: For large refactorings, break into smaller steps
7. **Document patterns**: Save complex patterns as rule files for reuse

## Integration with Other Tools

### With Git

```bash
# Search only in staged files
git diff --staged --name-only | xargs ast-grep --pattern 'console.log($$$)' --lang js

# Search in changed files
git diff --name-only | xargs ast-grep --pattern 'console.log($$$)' --lang js
```

### With Grep

Combine ast-grep with grep for hybrid searches:

```bash
# Find files with pattern, then use grep for context
ast-grep --pattern 'useEffect($$$)' --lang tsx --json | grep -o '"file":"[^"]*"'
```

### With Code Review

Use in pre-commit hooks or CI:

```bash
# In pre-commit hook
ast-grep scan --error-on-warning
```

## Troubleshooting

**Pattern not matching**:
- Check language specification (`--lang`)
- Verify pattern syntax (use ast-grep playground online)
- Try simpler pattern first, then add complexity
- Check metavariable syntax ($, $$, $$$)

**Too many matches**:
- Add more specific context to pattern
- Use constraints in YAML config
- Filter by file path

**Performance issues**:
- Specify explicit file paths
- Use more specific patterns
- Filter by language/extension

## Example Workflows

### Workflow 1: Remove All Console Logs

```bash
# 1. Find all console.log statements
ast-grep --pattern 'console.log($$$)' --lang js

# 2. Review matches
# 3. Remove them
ast-grep --pattern 'console.log($$$)' \
  --rewrite '' \
  --lang js \
  --interactive
```

### Workflow 2: Migrate to New API

```bash
# Migrate from old API to new API
# Old: user.getName()
# New: user.profile.name

# 1. Find pattern
ast-grep --pattern '$USER.getName()' --lang ts

# 2. Replace
ast-grep --pattern '$USER.getName()' \
  --rewrite '$USER.profile.name' \
  --lang ts \
  --update-all
```

### Workflow 3: Security Audit

```bash
# Find all potential XSS vulnerabilities
ast-grep --pattern 'dangerouslySetInnerHTML={{ __html: $$$ }}' --lang jsx

# Find SQL injection patterns
ast-grep --pattern '"SELECT * FROM " + $$$' --lang js

# Find eval usage
ast-grep --pattern 'eval($$$)' --lang js
```

## Resources

- Official docs: https://ast-grep.github.io/
- Playground: https://ast-grep.github.io/playground.html
- Rule repository: https://github.com/ast-grep/ast-grep/tree/main/crates/config/src/rule
- GitHub: https://github.com/ast-grep/ast-grep

## Quick Reference

```bash
# Search
ast-grep --pattern '<pattern>' --lang <lang>

# Search with context
ast-grep --pattern '<pattern>' --lang <lang> -C 3

# Search and replace (dry run)
ast-grep --pattern '<pattern>' --rewrite '<replacement>' --lang <lang>

# Search and replace (interactive)
ast-grep --pattern '<pattern>' --rewrite '<replacement>' --lang <lang> --interactive

# Search and replace (apply all)
ast-grep --pattern '<pattern>' --rewrite '<replacement>' --lang <lang> --update-all

# Scan with rules
ast-grep scan

# JSON output
ast-grep --pattern '<pattern>' --lang <lang> --json
```
