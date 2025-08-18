#!/bin/bash

# Telegram Notification Script
# Usage: ./telegram-notify.sh "title" "message" [priority]

# Check for required environment variables
if [[ -z "$CLAUDE_TELEGRAM_BOT_TOKEN" || -z "$MY_TELEGRAM_CHAT_ID" ]]; then
    echo "Error: CLAUDE_TELEGRAM_BOT_TOKEN and MY_TELEGRAM_CHAT_ID must be set"
    exit 1
fi

TELEGRAM_BOT_TOKEN="$CLAUDE_TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$MY_TELEGRAM_CHAT_ID"

# Parse arguments
TITLE="${1:-Claude Secretary}"
MESSAGE="${2:-No message provided}"
PRIORITY="${3:-normal}"  # normal, high, urgent

# Add emoji based on priority
case "$PRIORITY" in
    urgent)
        EMOJI="🚨"
        ;;
    high)
        EMOJI="⚠️"
        ;;
    bug)
        EMOJI="🐛"
        ;;
    completed)
        EMOJI="✅"
        ;;
    info)
        EMOJI="ℹ️"
        ;;
    findings)
        EMOJI="💡"
        ;;
    *)
        EMOJI="📋"
        ;;
esac

# Get current timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Format the message
TELEGRAM_MESSAGE="${EMOJI} ${TITLE}

${MESSAGE}

⏰ ${TIMESTAMP}"

# Truncate if too long for Telegram (max 4096 chars)
if [[ ${#TELEGRAM_MESSAGE} -gt 4000 ]]; then
    TELEGRAM_MESSAGE="${TELEGRAM_MESSAGE:0:3997}..."
fi

# Send to Telegram
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d "{
    \"chat_id\": \"${TELEGRAM_CHAT_ID}\",
    \"text\": \"${TELEGRAM_MESSAGE}\",
    \"parse_mode\": \"HTML\"
  }")

# Check if successful
if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "Notification sent successfully"
    exit 0
else
    echo "Failed to send notification: $RESPONSE"
    exit 1
fi