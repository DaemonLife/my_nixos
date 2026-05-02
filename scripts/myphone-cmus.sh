#!/usr/bin/env bash
CMUS_FOLDER="$HOME/Music/myphone"
PHONE_USERNAME=$1
PORT=$2

mkdir -p $CMUS_FOLDER && echo "Created new directory $CMUS_FOLDER"

umount $CMUS_FOLDER

(sshfs -p $PORT $PHONE_USERNAME@myphone:/data/data/com.termux/files/home/storage/music/my \
  $CMUS_FOLDER && cmus 2>/dev/null || echo "All done!") || echo "Can\'t connect."
