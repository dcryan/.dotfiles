#!/bin/bash

LOG="/tmp/claude_speak_summary.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"
}

extract_summary() {
    grep -o '\[SPOKEN_SUMMARY\]: .*' | sed 's/\[SPOKEN_SUMMARY\]: //' | head -c 200
}

log "=== Hook invoked ==="

# Brightness check first — cheap (~50ms) vs Swift compilation (~500ms)
BRIGHTNESS=$(ioreg -rc IOMobileFramebuffer 2>/dev/null | grep '"IOMFBBrightnessLevel"' | head -1 | grep -oE '[0-9]+$')
log "Screen brightness: $BRIGHTNESS"
if [ "$BRIGHTNESS" = "0" ]; then
    log "MUTED: Screen brightness is zero"
    exit 0
fi

# CoreAudio HAL check — no TCC microphone permission needed
AUDIO_STATE=$(swift -e '
import CoreAudio
func isRunning(_ selector: AudioObjectPropertySelector) -> Bool {
    var da = AudioObjectPropertyAddress(mSelector: selector, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMain)
    var id: AudioDeviceID = 0; var sz = UInt32(MemoryLayout<AudioDeviceID>.size)
    AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &da, 0, nil, &sz, &id)
    var ra = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDeviceIsRunningSomewhere, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMain)
    var r: UInt32 = 0; sz = UInt32(MemoryLayout<UInt32>.size)
    AudioObjectGetPropertyData(id, &ra, 0, nil, &sz, &r)
    return r != 0
}
let mic = isRunning(kAudioHardwarePropertyDefaultInputDevice)
let out = isRunning(kAudioHardwarePropertyDefaultOutputDevice)
print("\(mic),\(out)")
' 2>/dev/null)
MIC_IN_USE="${AUDIO_STATE%%,*}"
AUDIO_PLAYING="${AUDIO_STATE##*,}"
log "Mic in use: $MIC_IN_USE, Audio playing: $AUDIO_PLAYING"
if [ "$MIC_IN_USE" = "true" ]; then
    log "MUTED: Microphone is active (likely on a call)"
    exit 0
elif [ "$AUDIO_PLAYING" = "true" ]; then
    log "MUTED: Audio/video is playing on output device"
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

