#!/usr/bin/env bash
# Current workspace number
FOCUSED_WORKSPACE_NUM=$(swaymsg -t get_workspaces | jq --raw-output '. | map(select(.focused == true)) | .[0].name' | awk '{print $1}')

# Find the next workspace number
if [[ $1 == "next" ]]; then
  if [ "$FOCUSED_WORKSPACE_NUM" -ge 0 ] && [ "$FOCUSED_WORKSPACE_NUM" -lt 10 ]; then
    TARGET_WORKSPACE_NUM=$(expr ${FOCUSED_WORKSPACE_NUM} + 1)
  else
    TARGET_WORKSPACE_NUM=1
  fi
elif [[ $1 == "prev" ]]; then
  if [ "$FOCUSED_WORKSPACE_NUM" -gt 1 ] && [ "$FOCUSED_WORKSPACE_NUM" -le 10 ]; then
    TARGET_WORKSPACE_NUM=$(expr ${FOCUSED_WORKSPACE_NUM} - 1)
  else
    TARGET_WORKSPACE_NUM=10
  fi
fi

swaymsg "workspace ${TARGET_WORKSPACE_NUM}"
