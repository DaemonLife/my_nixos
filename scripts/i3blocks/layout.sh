#!/bin/bash

# echo $(setxkbmap -query | grep layout | awk '{print $2}' | sed 's/,.*$//g')

# Output current layout:
xkb-switch -p 
