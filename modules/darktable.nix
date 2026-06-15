{
  pkgs,
  config,
  stylix,
  ...
}:
# Rusticl start:
# ROC_ENABLE_PRE_VEGA=1 RUSTICL_ENABLE=amdgpu,amdgpu-pro,radv,radeon,radeonsi DRI_PRIME=0 QT_QPA_PLATFORM=xcb darktable
# or simple:
# RUSTICL_ENABLE=amdgpu,amdgpu-pro,radv,radeon,radeonsi darktable
# add the variable to autostart!!!
let
  theme = ''
    /* --- My variables --- */

    @define-color accent_1 #7daea3;
    @define-color accent_2 #d8a657;

    /* --- Lightable and darktable film --- */

    @define-color thumbnail_bg_color @grey_45;
    @define-color lighttable_bg_color @thumbnail_bg_color;
    @define-color thumbnail_hover_bg_color @accent_1;
    @define-color thumbnail_selected_bg_color @accent_2;
    @define-color thumbnail_font_color @grey_20;
    @define-color thumbnail_fg_color @grey_90;
    @define-color thumbnail_hover_fg_color @grey_90;
    @define-color thumbnail_localcopy_color @grey_90;

    /* --- Active or hover image --- */

    .dt_act_on_hover #thumb-main:active #thumb-back,
    .dt_act_on_hover #thumb-main:selected #thumb-back,
    .dt_act_on_selection #thumb-main:hover #thumb-back {
            border: none;
    }
    .dt_overlays_hover_extended #thumb-main:hover #thumb-bottom,
    .dt_overlays_mixed #thumb-main:hover #thumb-bottom,
    .dt_overlays_hover #thumb-main:hover #thumb-bottom {
            background-image: none;
            background-color: @thumbnail_hover_bg_color;
    }

    /* --- Other --- */
  '';
in {}
