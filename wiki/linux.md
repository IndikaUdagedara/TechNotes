# Linux

## Audio Stack

The Linux audio architecture has multiple layers:

- **ALSA** (Advanced Linux Sound Architecture) – kernel driver layer that interfaces directly with hardware
- **PulseAudio** / **PipeWire** – user-space sound servers built on top of ALSA

PipeWire (the modern replacement for PulseAudio) does **not** manage hardware-level ALSA mixer controls like `Capture` and `Mic Boost`. These must be configured via ALSA tools directly.

### Troubleshooting Internal Microphone

If the internal mic stops working (e.g., no audio in Google Meet):

1. Check if the mic mute LED is active:
   ```bash
   cat /sys/class/leds/platform::micmute/brightness
   # 1 = muted, 0 = unmuted
   ```

2. List ALSA cards and identify the codec (e.g., ALC257):
   ```bash
   cat /proc/asound/cards
   ```

3. Check and fix mixer controls with `amixer`:
   ```bash
   # View current settings for card 1
   amixer -c 1 contents

   # Unmute Capture and set volume (0-100%)
   amixer -c 1 set Capture 70% unmute

   # Set Mic Boost (0=0dB, 1=+10dB, 2=+20dB, 3=+30dB)
   amixer -c 1 set 'Mic Boost' 1
   ```

See [nix](nix.md#alsa-mixer-persistence) for persisting these settings across reboots on NixOS.

---

*Entry: [../raw/2026-07-16.md#75ffb977be85](../raw/2026-07-16.md#75ffb977be85)*
