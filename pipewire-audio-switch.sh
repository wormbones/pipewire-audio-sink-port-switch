#!/usr/bin/env bash
# Authour: WormBones
# pipewire-audio-switch.sh - Cycle between audio sinks with friendly names
# Version: 1.5 (Fixed Parsing)
# Last Updated: 2026-03-11

# Configuration
LAST_SINK_FILE="/tmp/.last_audio_sink"
NOTIFY_ENABLED=true

# 1. Get all sinks (short list)
# We use awk to extract ONLY the 2nd column (the Name), skipping the ID (1st col)
# and ignoring monitors.
SINKS_SHORT=$(pactl list sinks short | grep -v '\.monitor' | awk '{print $2}')

# Convert to array
readarray -t SINK_NAMES <<< "$SINKS_SHORT"
NUM_SINKS=${#SINK_NAMES[@]}

# Safety check
if [ "$NUM_SINKS" -lt 1 ]; then
    echo "Error: No audio sinks found."
    exit 1
fi

if [ "$NUM_SINKS" -eq 1 ]; then
    echo "Only one sink available. Nothing to switch."
    exit 0
fi

CURRENT=$(pactl get-default-sink)
TARGET=""

# 2. Handle LAST_SINK logic
if [ -f "$LAST_SINK_FILE" ]; then
    LAST_SAVED=$(cat "$LAST_SINK_FILE")

    # Check if last saved is in our current list and not current
    for i in "${!SINK_NAMES[@]}"; do
        if [[ "${SINK_NAMES[$i]}" == "$LAST_SAVED" ]]; then
            if [ "$LAST_SAVED" != "$CURRENT" ]; then
                TARGET="$LAST_SAVED"
            fi
            break
        fi
    done
else
    echo "$CURRENT" > "$LAST_SINK_FILE"
fi

# 3. Cycle to next if no target found
if [ -z "$TARGET" ]; then
    FOUND_CURRENT=false
    for i in "${!SINK_NAMES[@]}"; do
        if [[ "${SINK_NAMES[$i]}" == "$CURRENT" ]]; then
            NEXT_IDX=$(( (i + 1) % NUM_SINKS ))
            TARGET="${SINK_NAMES[$NEXT_IDX]}"
            FOUND_CURRENT=true
            break
        fi
    done

    if [ "$FOUND_CURRENT" = false ]; then
        TARGET="${SINK_NAMES[0]}"
    fi
fi

# 4. Execute Switch
if [ -n "$TARGET" ] && [ "$TARGET" != "$CURRENT" ]; then
    pactl set-default-sink "$TARGET"
    echo "$TARGET" > "$LAST_SINK_FILE"

    if [ "$NOTIFY_ENABLED" = true ]; then
        # Extract Description for the TARGET sink
        # We use a simple grep -A 1 to find the line after "Name: <target>"
        # This is robust because we know the exact name from the array
        FRIENDLY_NAME=$(pactl list sinks | grep -A 1 "Name: $TARGET" | grep "Description:" | sed 's/Description: //')

        # Fallback if description is empty
        if [ -z "$FRIENDLY_NAME" ]; then
            FRIENDLY_NAME="$TARGET"
        fi

        notify-send "Audio Switched" "Now using: $FRIENDLY_NAME"
    fi
fi
