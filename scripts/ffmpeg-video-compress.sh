#!/usr/bin/env bash

if [ ! "$1" ]; then
  echo "Error. Select file."
  exit
fi

file="$1"

if [ "$2" ]; then
  extencion="$2"
else
  extencion="${file#*.}"
fi

ffmpeg -i "$file" -c:v libx264 -crf 23 -c:a copy "${file%%.*}_compressed.${extencion}"
