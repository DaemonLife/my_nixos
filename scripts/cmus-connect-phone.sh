#!/usr/bin/env bash
CMUS_FOLDER="$HOME/Music/myphone"

mkdir -p $CMUS_FOLDER && echo "Created new directory $CMUS_FOLDER";

( sshfs -p 8022 u0_a183@myphone:/data/data/com.termux/files/home/storage/music/my \
$CMUS_FOLDER && cmus 2> /dev/null || echo "All done!" ) || echo "Can\'t connect."
