#!/usr/bin/env bash
ROC_ENABLE_PRE_VEGA=1 RUSTICL_ENABLE=amdgpu,amdgpu-pro,radv,radeon,radeonsi DRI_PRIME=0 QT_QPA_PLATFORM=xcb darktable; dunstify "Darktable is closed"

