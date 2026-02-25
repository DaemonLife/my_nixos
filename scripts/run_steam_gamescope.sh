#!/usr/bin/env bash
set -xeuo pipefail

gamescopeArgs=(
  --adaptive-sync # VRR support
  # --hdr-enabled
  --mangoapp # performance overlay
  --rt
  --steam
  # --sdr-gamut-wideness 1 # or >=0
)
steamArgs=(
  -pipewire-dmabuf
  -tenfoot # Start in Steam Big Picture mode
)
mangoConfig=(
  custom_text="I_love_FROGS"
  cpu_temp
  gpu_temp
  ram
  vram
  font_size=20
  font_size_text=20
  position=top-left
  hud_compact
  # no_display
)
mangoVars=(
  MANGOHUD=1
  MANGOHUD_CONFIG="$(
    IFS=,
    echo "${mangoConfig[*]}"
  )"
)

export "${mangoVars[@]}"
exec gamescope "${gamescopeArgs[@]}" -- steam "${steamArgs[@]}"
