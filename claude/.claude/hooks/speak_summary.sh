#!/bin/bash

LOG="/tmp/claude_speak_summary.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"
}

extract_summary() {
    grep -o '\[SPOKEN_SUMMARY\]: .*' | sed 's/\[SPOKEN_SUMMARY\]: //' | head -c 200
}

log "=== Hook invoked ==="

HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
if bash "$HOOKS_DIR/should_mute.sh"; then
    log "MUTED: should_mute detected active audio or dimmed screen"
    exit 0
fi

INPUT=$(cat)

# Strategy 1: Extract from last_assistant_message
LAST_ASSISTANT=$(jq -r '.last_assistant_message // empty' <<< "$INPUT" 2>/dev/null)
log "last_assistant_message length: ${#LAST_ASSISTANT}"

if [ -n "$LAST_ASSISTANT" ]; then
    MSG=$(extract_summary <<< "$LAST_ASSISTANT")
    log "Strategy 1 extracted MSG: '$MSG'"
fi

# Strategy 2: Fallback — grep transcript directly (no jq needed)
if [ -z "$MSG" ]; then
    TRANSCRIPT_PATH=$(jq -r '.transcript_path' <<< "$INPUT")
    log "Trying transcript fallback: $TRANSCRIPT_PATH"

    if [ -f "$TRANSCRIPT_PATH" ]; then
        MSG=$(tail -2000 "$TRANSCRIPT_PATH" | extract_summary | tail -1)
        log "Strategy 2 extracted MSG: '$MSG'"
    else
        log "Transcript file not found at '$TRANSCRIPT_PATH'"
    fi
fi

if [ -z "$MSG" ]; then
    log "FALLBACK: No [SPOKEN_SUMMARY] marker found"
    MSG="Task completed"
fi

log "Final MSG: '$MSG'"

# Background TTS: render to file, play chime + voice back-to-back
(say "$MSG" -o /tmp/claude_tts.aiff && afplay /System/Library/Sounds/Funk.aiff && afplay -v 0.25 /tmp/claude_tts.aiff) &>/dev/null &

log "=== Hook complete ==="

