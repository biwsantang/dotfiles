# Claude Command: Rebase

This command helps you perform interactive rebases with smart commit management and conflict resolution.

## Usage

To rebase the current branch, just type:
```
/rebase
```

Or with options:
```
/rebase --onto main
/rebase --interactive
/rebase --continue
/rebase --abort
```

## Important Notes

- **Prerequisites**: Ensure all changes are committed before rebasing
- If there are uncommitted changes, the command will stop and ask you to commit or stash them first
- Always fetches origin first to ensure base branch comparison is current
- The command analyzes commit history to suggest the most appropriate rebase strategy
- Smart conflict detection and resolution suggestions
- **Handles rebase conflicts gracefully**: Provides clear guidance for resolving conflicts step-by-step
- Creates backup branch before destructive operations for safety

## Performance Improvements

The following optimizations significantly improve command execution speed:

- **Parallel git operations** - Run `git status`, `git fetch`, and branch analysis concurrently
- **Smart conflict detection** - Pre-analyze potential conflicts before starting rebase
- **Optimized commit analysis** - Use `git log --stat` for quick overview, detailed analysis only when needed
- **Streamlined rebase workflow** - Direct command execution without temporary files

## What This Command Does

```mermaid
flowchart TD
    A[Start: /rebase] --> B[Parallel Operations]
    B --> B1[Check git status]
    B --> B2[Fetch origin updates]
    B --> B3[Analyze current branch]
    B1 --> C[Wait for all parallel operations]
    B2 --> C
    B3 --> C
    C --> D{Uncommitted changes?}
    D -->|Yes| E[Stop: Ask user to commit/stash first]
    D -->|No| F[Determine target base branch]
    E --> END[Command stopped]
    F --> G[Create safety backup branch]
    G --> H[Pre-analyze potential conflicts]
    H --> I{Conflicts likely?}
    I -->|Yes| J[Warn user and suggest strategy]
    I -->|No| K[Execute rebase]
    J --> L{User wants to proceed?}
    L -->|No| END
    L -->|Yes| K
    K --> M{Rebase conflicts?}
    M -->|Yes| N[Guide conflict resolution]
    M -->|No| O[Success: Rebase completed]
    N --> P[Provide conflict resolution steps]
    P --> Q{Continue rebase?}
    Q -->|Yes| R[Continue with git rebase --continue]
    Q -->|No| S[Abort with git rebase --abort]
    R --> M
    S --> T[Restore from backup branch]
    T --> END
    
    style B fill:#87CEEB
    style B1 fill:#DDA0DD
    style B2 fill:#DDA0DD
    style B3 fill:#DDA0DD
    style G fill:#FFB6C1
    style H fill:#90EE90
    style N fill:#F0E68C
    style O fill:#90EE90
```

## Rebase Strategy Logic

```mermaid
flowchart LR
    A[Current Branch] --> B{Branch Pattern?}
    B -->|feature/*, fix/*| C{Target Branch?}
    B -->|develop| D[Rebase onto: main]
    B -->|hotfix/*| E[Rebase onto: main]
    
    C --> C1{develop exists?}
    C1 -->|Yes| F[Rebase onto: develop]
    C1 -->|No| G[Rebase onto: main]
    
    H[--onto flag] -->|Override| I[Rebase onto: specified branch]
    
    F --> J[Interactive rebase for cleanup]
    G --> J
    D --> J
    E --> K[Fast rebase for hotfix]
    I --> L[Custom rebase strategy]
    
    style F fill:#90EE90
    style G fill:#90EE90
    style D fill:#87CEEB
    style E fill:#FFB6C1
    style I fill:#DDA0DD
```

## Rebase Types and When to Use

- **Interactive Rebase** (`git rebase -i`): Clean up commit history, squash commits, reorder changes
- **Standard Rebase** (`git rebase`): Move branch to latest base without history modification
- **Onto Rebase** (`git rebase --onto`): Move commits from one base to another specific point
- **Continue** (`git rebase --continue`): Resume rebase after resolving conflicts
- **Abort** (`git rebase --abort`): Cancel rebase and return to original state

## Conflict Resolution Strategies

When conflicts occur during rebase:

1. **Analyze conflict markers**: Understand `<<<<<<<`, `=======`, and `>>>>>>>` sections
2. **Identify conflict types**: Code conflicts, dependency conflicts, merge conflicts
3. **Resolution approaches**:
   - **Accept incoming**: Take changes from target branch
   - **Accept current**: Keep changes from current branch
   - **Manual merge**: Combine both sets of changes intelligently
4. **Validate resolution**: Ensure code still works after conflict resolution
5. **Continue rebase**: Use `git rebase --continue` after resolving all conflicts

## Common Scenarios and Error Handling

```mermaid
flowchart TD
    A[Rebase Execution] --> B{Scenario Type?}
    B -->|Clean rebase| C[Success: No conflicts]
    B -->|Merge conflicts| D[Guide conflict resolution]
    B -->|Uncommitted changes| E[Stop: Ask to commit/stash]
    B -->|Detached HEAD| F[Create recovery branch]
    B -->|Force push needed| G[Warn about shared branch]
    
    C --> H[Rebase completed successfully]
    D --> I[Provide step-by-step conflict resolution]
    I --> J[Continue or abort options]
    E --> K[Stop: Clean working directory first]
    F --> L[Help recover branch state]
    G --> M[Suggest safer alternatives]
    
    style C fill:#90EE90
    style H fill:#90EE90
    style D fill:#F0E68C
    style I fill:#F0E68C
    style K fill:#FFB6C1
    style M fill:#FFB6C1
```

### Scenario 1: Clean Rebase
- No conflicts detected during rebase
- Branch history updated successfully
- Ready for push or further development

### Scenario 2: Merge Conflicts
- **Issue**: Conflicting changes between branches
- **Solution**: Guide user through conflict resolution process
- Identify conflict types and suggest resolution strategies
- Provide commands to continue or abort rebase

### Scenario 3: Uncommitted Changes
- **Issue**: Working directory has uncommitted changes
- **Solution**: Command stops and prompts user to commit or stash changes first

### Scenario 4: Shared Branch Warning
- **Issue**: Rebasing a branch that others might be using
- **Solution**: Warn about force push implications and suggest alternatives

## Best Practices for Rebasing

- **Never rebase shared branches**: Only rebase branches that haven't been pushed or shared
- **Create backup branches**: Always create safety backups before destructive operations
- **Rebase before merge**: Clean up commit history before creating pull requests
- **Interactive rebase for cleanup**: Use interactive mode to squash, reorder, or edit commits
- **Test after rebase**: Ensure functionality still works after history modification
- **Communicate with team**: Inform team members about rebased shared branches

## Examples

Good rebase scenarios:
- `feat/user-auth` rebased onto latest `develop`
- Interactive rebase to squash multiple small commits into logical units
- Moving feature branch from `main` to `develop` using `--onto`
- Cleaning up commit messages and removing debug commits

Example interactive rebase plan:
```
pick a1b2c3d feat: add user authentication
squash e4f5g6h fix: typo in auth function  
squash h7i8j9k fix: linting issues
pick k10l11m docs: update auth documentation
reword n12o13p test: add auth unit tests
```

## Safety Features

- **Automatic backup creation**: Creates `backup/<branch-name>` before rebasing
- **Conflict pre-analysis**: Warns about potential conflicts before starting
- **Step-by-step guidance**: Provides clear instructions during conflict resolution
- **Easy abort option**: Simple command to cancel and restore original state
- **Validation checks**: Ensures working directory is clean before starting
- **Force push warnings**: Alerts about implications of rewriting shared history