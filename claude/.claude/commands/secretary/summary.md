# Secretary Summary Command

Summarize the current work session and send a progress update via Telegram.

## Instructions:

1. Review the current conversation and work being done
2. Identify key accomplishments and progress made
3. List any pending tasks or blockers
4. Create a concise summary (max 500 characters)
5. Send the summary using:
   ```bash
   $HOME/.claude/scripts/telegram-notify.sh "Work Summary" "[your summary here]" "info"
   ```

## Summary should include:
- Main task or goal
- Progress percentage (estimate)
- Key accomplishments
- Current status
- Next steps

## Example:
```
Task: Implementing user authentication
Progress: 70% complete
✓ Created login form
✓ Set up JWT tokens
⚡ Working on password reset
→ Next: Email verification
```