#!/usr/bin/env bash
# Version: 1.2
# Author: WormBones
# Last Updated: 2026-03-11

NOTIFY_ENABLED=true
WANTED_SINK="alsa_output.pci-0000_0b_00.6.analog-stereo"

# Track which port we're switching TO
NEW_PORT=""

if pactl list sinks | grep -q "Active Port:.*analog-output-headphones"; then
    pactl set-sink-port "$WANTED_SINK" analog-output-lineout
    NEW_PORT="Line Out"
elif pactl list sinks | grep -q "Active Port:.*analog-output-lineout"; then
    pactl set-sink-port "$WANTED_SINK" analog-output-headphones
    NEW_PORT="Headphones"
else
    echo "Unknown port state"
    exit 1
fi

# Notification
if [ "$NOTIFY_ENABLED" = true ]; then
    notify-send "Ryzen HD Analog Stereo Port Switched" "Now using: $NEW_PORT"
fi
