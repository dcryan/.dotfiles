#!/bin/bash


# Read hook input data from stdin
INPUT=$(cat)

# Extract transcript path
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')

# Extract spoken summary from transcript
if [ -f "$TRANSCRIPT_PATH" ]; then
    # Look for [SPOKEN_SUMMARY]: marker in last assistant message
    # Use jq -s to slurp all lines and get the last assistant message properly
    MSG=$(tail -100 "$TRANSCRIPT_PATH" | \
          jq -rs '[.[] | select(.type == "assistant" and .message.role == "assistant")] | last | .message.content[0].text // empty' | \
          grep -o '\[SPOKEN_SUMMARY\]: .*' | \
          sed 's/\[SPOKEN_SUMMARY\]: //' | \
          head -c 200)

    # Fallback if no marker found
    MSG=${MSG:-"Task completed"}
else
    MSG="Task completed"
fi

# Generate TTS first, then play Funk + voice back-to-back (no gap)
# All in background subshell so hook returns immediately
(say "$MSG" -o /tmp/claude_tts.aiff && afplay /System/Library/Sounds/Funk.aiff && afplay -v 0.25 /tmp/claude_tts.aiff) &>/dev/null &
echo $! > /tmp/claude_say_pid
disown 2>/dev/null

