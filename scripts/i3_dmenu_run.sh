#!/usr/bin/env bash

# setxkbmap -layout us,ru && dmenu_run -i -fn 'Unifont-20'
setxkbmap -layout us,ru && kitty sh -c "fsel -d"
