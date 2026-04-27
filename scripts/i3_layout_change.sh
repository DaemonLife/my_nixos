#!/usr/bin/env bash

current=$(setxkbmap -query | grep layout | awk '{print $2}')

if [[ $current != "us,ru" ]]; then
    new="us,ru"
else
    new="ru,us"
fi

setxkbmap -layout $new

