#!/usr/bin/env bash

file="$1"
width="$2"
height="$3"

meta_lines=6
img_height=$((height - meta_lines))


# изображение
# chafa -s "${width}x${img_height}" "$file"
kitty icat "$file"

# метаданные
echo
jxlinfo "$file"
