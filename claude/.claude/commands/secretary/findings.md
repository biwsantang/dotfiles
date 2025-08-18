# Secretary Important Findings Command

Report important discoveries, insights, or critical information found during work.

## Instructions:

1. Identify the important finding or insight
2. Explain why it's significant
3. Provide context and implications
4. Send finding notification:
   ```bash
   $HOME/.claude/scripts/telegram-notify.sh "Important Finding" "[finding details]" "findings"
   ```

## Finding Report Format:
```
💡 Discovery: [What was found]
📁 Location: [Where found - file:line]
❗ Significance: [Why it matters]
🔍 Details:
  - [Key detail 1]
  - [Key detail 2]
  - [Key detail 3]
⚠️ Impact: [Potential consequences]
✅ Recommendation: [Suggested action]
```

## Types of Important Findings:
- Security vulnerabilities
- Performance bottlenecks
- Deprecated code usage
- Potential improvements
- Architectural issues
- Missing documentation
- Configuration problems
- Dependency conflicts
- Code quality issues
- Business logic flaws