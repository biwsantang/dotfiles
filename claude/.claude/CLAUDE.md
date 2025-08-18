# Claude Secretary System

This project has a secretary agent system that monitors work and sends Telegram notifications for important events.

## Secretary Agent

The secretary agent is defined at: @agents/secretary.md

This agent monitors Claude's activities and decides when to send notifications via Telegram.

## How to Use the Secretary Agent

Use the Task tool with `subagent_type: "secretary"` to invoke the secretary agent for sending notifications.

## When to Invoke Secretary

**Automatically invoke the secretary agent when:**

1. **Task Completion** - When finishing significant tasks or features
   - Priority: `completed`
   - Command reference: @commands/secretary/completed (if available)
   
2. **Bug Discovery** - When encountering errors or bugs  
   - Priority: `bug`
   - Command reference: @commands/secretary/bug (if available)
   
3. **Important Findings** - When discovering critical information, security issues, or insights
   - Priority: `findings`
   - Command reference: @commands/secretary/findings (if available)
   
4. **Progress Updates** - Periodically summarize work progress (every 5-10 significant actions)
   - Priority: `info`
   - Command reference: @commands/secretary/summary (if available)

## Priority Guidelines

- **Urgent**: Security vulnerabilities, data loss risks, system failures
- **High**: Critical bugs, blocking issues, important discoveries  
- **Normal**: Task completions, regular updates, minor findings

## Telegram Configuration

Ensure these environment variables are set:
- `CLAUDE_TELEGRAM_BOT_TOKEN`
- `MY_TELEGRAM_CHAT_ID`

## Telegram Script

The secretary agent uses the script located at:
`$HOME/.claude/scripts/telegram-notify.sh`

Usage: `telegram-notify.sh "title" "message" "priority"`

Priority levels: normal, high, urgent, bug, completed, info, findings

## Example Usage

### Using the Task Tool (Primary Method)
When you complete a feature, use the Task tool:
```
Task tool with:
- subagent_type: "secretary"
- description: "Send completion notification"
- prompt: "Send a notification that [describe what was completed]. Use priority: completed"
```

### Using Slash Commands (If Available)
If custom commands are set up in @commands/secretary/:
```
/secretary/completed Task completed: [description]
/secretary/bug Bug found: [description]
/secretary/findings Important finding: [description]
/secretary/summary Progress update: [description]
```

## Important Notes

- Don't spam notifications - batch minor updates
- Always include actionable information
- Provide file paths and line numbers when relevant
- Be concise but informative in messages
- Custom commands should be placed in ~/.claude/commands/ for user-level or .claude/commands/ for project-level access