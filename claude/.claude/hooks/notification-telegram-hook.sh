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

# Extract fields using jq
MESSAGE=$(echo "$INPUT" | jq -r '.message // "No message"')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""')
CWD=$(echo "$INPUT" | jq -r '.cwd // "Unknown directory"')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "Unknown session"')

# Only send notification when Claude is waiting for input
# if [[ "$MESSAGE" != "Claude is waiting for your input" ]]; then
#    exit 0
# fi

# Get the latest Claude response from the transcript
LATEST_CLAUDE_RESPONSE="No response available"
if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
    # Read the last assistant message from the JSONL transcript
    # Each line in JSONL is a separate JSON object
    # Filter for assistant messages and extract text content
    LATEST_CLAUDE_RESPONSE=$(tail -100 "$TRANSCRIPT_PATH" | \
        jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text' 2>/dev/null | \
        tail -1)
    
    # If no assistant message found or empty, set default
    if [[ -z "$LATEST_CLAUDE_RESPONSE" ]]; then
        LATEST_CLAUDE_RESPONSE="No assistant response found"
    fi
    
    # Truncate if too long for Telegram (max 4096 chars)
    if [[ ${#LATEST_CLAUDE_RESPONSE} -gt 3500 ]]; then
        LATEST_CLAUDE_RESPONSE="${LATEST_CLAUDE_RESPONSE:0:3497}..."
    fi
fi

# Format the message for Telegram
TELEGRAM_MESSAGE="🔔 Claude Code - Waiting for Input

📝 Latest Response:
${LATEST_CLAUDE_RESPONSE}

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
