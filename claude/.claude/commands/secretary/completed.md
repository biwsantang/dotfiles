# Secretary Task Completion Command

Notify when significant tasks or milestones are completed.

## Instructions:

1. Identify completed task or milestone
2. Summarize what was accomplished
3. Include any relevant metrics or results
4. Send completion notification:
   ```bash
   $HOME/.claude/scripts/telegram-notify.sh "Task Completed" "[completion details]" "completed"
   ```

## Completion Report Format:
```
✅ Completed: [Task name]
⏱️ Time taken: [duration]
📈 Results:
  - [Key achievement 1]
  - [Key achievement 2]
  - [Key achievement 3]
📊 Metrics:
  - Files modified: X
  - Lines added/removed: +X/-Y
  - Tests passed: X/Y
🎯 Next: [What's next]
```

## When to Send:
- Feature implementation complete
- Major bug fix resolved
- Refactoring finished
- Tests all passing
- Deployment successful
- Documentation updated