#!/usr/bin/env bash
# https://github.com/stgiga/UnifontEX

# font name: Unifont

mkdir ~/.local/share/fonts/
cp * ~/.local/share/fonts/
fc-cache -fv

fc-list | grep Unifont
