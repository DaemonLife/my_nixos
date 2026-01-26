#!/usr/bin/env bash

tick_tock=1
green=$(tput setaf 2)
yellow=$(tput setaf 3)
white=$(tput setaf 7)
bold=$(tput bold)
dim=$(tput dim)
star="O"
ball="o"
sleep=0.07
area_reduce=3 # 1-5 or more
star_flash_chance=8 # 1-10

main() {
  cols=$(tput cols)
  rows=$(tput lines)
  rows=$rows+1 # TEST!
  center=$((cols / 2))
  max_H=$(((rows - 4) / 4 - 1))
  max_W=$(((cols - 15) / 8 - 1))
  tree_size=$((max_H < max_W ? max_H : max_W))
  tput clear
  tree_area
  grow_tree
  loop
}

loop() {
  while true; do
    lights
    draw_star
    if (($((RANDOM % 10 + 1)) < $star_flash_chance)); then 
        tick_tock=$((1 - tick_tock))
    fi
    sleep $sleep
  done
}

addchar() {
  tput cup "$1" $((center + "$2"))
  echo "$3"
}

colour_blink() {
  if (($1 == 1)); then
    echo "$bold"
  else
    echo "$dim"
  fi
  echo "$2"
}

draw_star() {
  colour_blink "$tick_tock" "$yellow"
  addchar 3 0 "$star"

  colour_blink "$tick_tock" "$white"
  addchar 2 1 "/"
  addchar 4 -1 "/"
  addchar 2 -1 "\\"
  addchar 4 1 "\\"

  addchar 3 2 "-"
  addchar 3 -2 "-"

  addchar 1 0 "|"
  addchar 5 0 "|"

  colour_blink $((1 - tick_tock)) "$white"
  addchar 3 1 "="
  addchar 3 -1 "="
  addchar 2 0 "|"
  addchar 4 0 "|"

  addchar 3 3 "-"
  addchar 3 -3 "-"
  tput sgr0
}

tree_area() {
  for ((i = 0; i < tree_size; i++)); do
    for ((j = 0; j < 4; j++)); do
      k=$((4 * i + j))
      w[k]=$((8 * i + 4 * j + 1))
      area=$((${w[@]/%/+}0))
    done
  done
}

grow_tree() {
  echo "$green"
  for ((i = 0; i < tree_size; i++)); do
    for ((j = 0; j < 4; j++)); do
      addchar $((4 * i + j + 4)) $((4 * i + 2 * j + 1)) "\\"
      addchar $((4 * i + j + 4)) $((-4 * i - 2 * j - 1)) "/"
    done
  done
  tput sgr0
}

lights() {
  # off
  for ((i = 0; i < tree_size; i++)); do
    for ((j = 0; j < 4; j++)); do
      tput cup $((4 * i + j + 4)) $((center - 4 * i - 2 * j))
      tput ech $((8 * i + 4 * j))
    done
  done
  # on
  for ((i = 0; i < area / $area_reduce; i++)); do
    tree_H=${#w[*]}
    random_pre_y=$((RANDOM % tree_H))
    random_pre_x=$((RANDOM % cols))
    if ((random_pre_x < w[random_pre_y])); then
      random_y=$((random_pre_y + 4))
      random_x=$(((random_pre_x - 1) / 2))
      if ((RANDOM % 2 == 1)); then
        random_x=$((-random_x))
      fi
      tput setaf $((RANDOM % 5 + 1))
      addchar $random_y $random_x $ball
    fi
  done
  tput sgr0
}

safe_shutdown() {
  tput cnorm
  tput sgr0
  tput clear
  exit 0
}

trap main WINCH
trap safe_shutdown SIGINT

tput civis
main
