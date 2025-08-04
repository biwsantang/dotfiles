#!/bin/bash

# Telegram Bot Configuration
# Exit if required environment variables are not set
if [[ -z "$CLAUDE_TELEGRAM_BOT_TOKEN" || -z "$MY_TELEGRAM_CHAT_ID" ]]; then
    exit 0
fi

TELEGRAM_BOT_TOKEN="$CLAUDE_TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$MY_TELEGRAM_CHAT_ID"

# Read JSON input from stdin
INPUT=$(cat)

# Extract message and cwd using jq
MESSAGE=$(echo "$INPUT" | jq -r '.message // "No message"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "Unknown directory"')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "Unknown session"')

# Format the message for Telegram
TELEGRAM_MESSAGE="🔔 Claude Code Notification

📝 Message: $MESSAGE
📂 Directory: $CWD
🆔 Session: $SESSION_ID"

# Send to Telegram Bot API
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d "{
    \"chat_id\": \"${TELEGRAM_CHAT_ID}\",
    \"text\": \"${TELEGRAM_MESSAGE}\",
    \"parse_mode\": \"HTML\"
  }")

echo "Telegram API Response: $RESPONSE"

# Exit with success (hooks should not block Claude Code)
exit 0