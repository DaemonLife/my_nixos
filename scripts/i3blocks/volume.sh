#!/usr/bin/env bash

#--------------------------------------------------
# Mixer autodetection
#--------------------------------------------------
if [[ -z "$MIXER" ]] ; then
    MIXER="default"
    if command -v pulseaudio >/dev/null 2>&1 && pulseaudio --check ; then
        if amixer -D pulse info >/dev/null 2>&1 ; then
            MIXER="pulse"
        fi
    fi
    [ -n "$(lsmod | grep jack)" ] && MIXER="jackplug"
    MIXER="${2:-$MIXER}"
fi

#--------------------------------------------------
# Simple control
#--------------------------------------------------
if [[ -z "$SCONTROL" ]] ; then
    SCONTROL="${BLOCK_INSTANCE:-$(amixer -D $MIXER scontrols |
        sed -n "s/Simple mixer control '\([^']*\)',0/\1/p" |
        head -n1
    )}"
fi

#--------------------------------------------------
# Volume step
#--------------------------------------------------
if [[ -z "$STEP" ]] ; then
    STEP="${1:-5%}"
fi

#--------------------------------------------------
# Natural mapping
#--------------------------------------------------
NATURAL_MAPPING=${NATURAL_MAPPING:-0}
if [[ "$NATURAL_MAPPING" != "0" ]] ; then
    AMIXER_PARAMS="-M"
fi

#--------------------------------------------------
# Functions
#--------------------------------------------------

# Return "Capture" if device supports capture
capability() {
    amixer $AMIXER_PARAMS -D $MIXER get $SCONTROL |
        sed -n "s/  Capabilities:.*cvolume.*/Capture/p"
}

# Get volume info
volume() {
    amixer $AMIXER_PARAMS -D $MIXER get $SCONTROL $(capability)
}

# Get default sink name (between __ and __)
default_device() {
    if command -v pactl >/dev/null 2>&1; then
        pactl info 2>/dev/null |
            sed -n 's/^Default Sink: //p' |
            sed -n 's/.*__\([^_][^_]*\)__.*/\1/p'
    else
        echo "$SCONTROL"
    fi
}

# Show "mic" if capture is enabled
mic_status() {
    amixer 2>/dev/null |
        grep -q 'Capture.*\[on\]' && echo " mic"
}

# Format output
format() {
    device="$(default_device)"
    device="${device,,}" # lowercase
    mic="$(mic_status)"

    perl_filter='if (/.*\[(\d+%)\] (\[(-?\d+.\d+dB)\] )?\[(on|off)\]/)'
    perl_filter+='{CORE::say $4 eq "off" ? "MUTE" : "'
    perl_filter+=$([[ $STEP = *dB ]] && echo '$3' || echo '$1')
    perl_filter+='"; exit}'

    output=$(perl -ne "$perl_filter")

    echo "$LABEL$device: $output$mic"
}

#--------------------------------------------------
# Mouse actions (i3blocks)
#--------------------------------------------------
case $BLOCK_BUTTON in
  1) pavucontrol &>/dev/null & ;; # L
  2) helvum &>/dev/null & ;; # M
  3) amixer $AMIXER_PARAMS -q -D $MIXER sset $SCONTROL $(capability) toggle ;; # R mute
  4) amixer $AMIXER_PARAMS -q -D $MIXER sset $SCONTROL $(capability) ${STEP}+ unmute ;; # up
  5) amixer $AMIXER_PARAMS -q -D $MIXER sset $SCONTROL $(capability) ${STEP}- unmute ;; # down
esac

#--------------------------------------------------
# Output
#--------------------------------------------------
volume | format
