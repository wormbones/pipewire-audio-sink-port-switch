# PipeWire Audio Switch Scripts

Personal utility scripts for managing audio sinks and ports on my Linux systems with PipeWire/WirePlumber. In order for the sink port switching to work properly you need to toggle the auto-mute. I have a two port sink ( Headphones and Line-Out ) But if my headphones are plugged in, the Line-Out would be muted even if it was selected to output. That's the only prior requirement for this to work. Otherwise it's a simple thing I wanted to write up.

## !! ⚠️ WARNING: Personal Configuration

**These scripts are configured for my specific hardware setup.** Several values are hardcoded:

- **Sink names** (e.g., `alsa_output.pci-0000_0b_00.6.analog-stereo`)
- **Port names** (e.g., `analog-output-headphones`, `analog-output-lineout`)
- **Notification settings**

If you clone this repository, you **must** edit the scripts to match your own hardware before use. Running them as-is may not work or could cause unexpected behavior. I'm using KDE/Plasma and just set the SHORTCUTS to script/command and the Keybinding I choose.

## Scripts

### `pipewire-audio-switch.sh`
Cycles between available audio sinks with friendly name notifications.

**Features:**
- Toggles between current and last-used sink
- Falls back to cycling through all available sinks
- Displays human-readable device names in notifications
- Stores last sink state in `/tmp/.last_audio_sink`

**My Personal Choice for Keybinding:** `SHIFT+CTL+F12`

### `pipewire-port-switch.sh`
Toggles between headphone and lineout ports on a specific sink.

**Features:**
- Detects current active port
- Switches to the alternate port
- Displays human-readable port names in notifications

**My Personal Choice for Keybinding:** `SHIFT+F12`

## Requirements

- PipeWire with PulseAudio compatibility layer (`pactl`)
- `notify-send` (libnotify) for desktop notifications
- Bash 4.0+ (for associative arrays)

## Installation

1. Clone or copy scripts to your preferred location(e.g.):
   ```bash
   mkdir -p ~/.locale/share/pipewire-audio-sink-port-switch/bin
   cp pipewire-* ~/.locale/share/pipewire-audio-sink-port-switch/bin
   chmod +x ~/.locale/share/pipewire-audio-sink-port-switch/bin/pipewire-*
