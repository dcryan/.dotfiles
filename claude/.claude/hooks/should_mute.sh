#!/bin/bash
# Shared mute detection: exits 0 if audio should be muted, 1 if clear to play.
# Usage: bash should_mute.sh && exit 0  (or source it)

# Brightness check first — cheap (~50ms) vs Swift compilation (~500ms)
BRIGHTNESS=$(ioreg -rc IOMobileFramebuffer 2>/dev/null | grep '"IOMFBBrightnessLevel"' | head -1 | grep -oE '[0-9]+$')
if [ "$BRIGHTNESS" = "0" ]; then
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
if [ "$MIC_IN_USE" = "true" ] || [ "$AUDIO_PLAYING" = "true" ]; then
    exit 0
fi

exit 1
