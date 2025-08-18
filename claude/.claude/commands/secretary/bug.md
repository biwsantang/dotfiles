# Secretary Bug Report Command

Report bugs or errors encountered during development via Telegram.

## Instructions:

1. Identify the bug or error
2. Gather relevant information:
   - Error message
   - File and line number
   - Steps to reproduce
   - Severity level
3. Send bug report using:
   ```bash
   $HOME/.claude/scripts/telegram-notify.sh "Bug Report" "[bug details]" "bug"
   ```

## Bug Report Format:
```
🐛 Bug: [Brief description]
📁 File: [path:line]
❌ Error: [error message]
🔄 Reproduce: [steps]
🎯 Impact: [Low/Medium/High/Critical]
💡 Possible fix: [suggestion]
```

## Severity Guidelines:
- **Critical**: System crash, data loss, security issue
- **High**: Feature broken, blocking progress
- **Medium**: Functionality impaired, workaround exists
- **Low**: Minor issue, cosmetic problem