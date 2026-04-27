{ pkgs, config, lib, ... }: {
  # lenovo output, command: swaymsg -t get_outputs
  wayland.windowManager.sway = {
    config = rec {
      output =
        let
          msk = {
            w = 2560;
            h = 1440;
            scale = 1.6; # 1, 1.6 or 2 is optimal
            position_w = 0;
            position_h = 400;
          };

          gg = {
            w = 1920;
            h = 1080;
            scale = 1;
            position_w = 2720;
            position_h = 312;
          };

          lenovo = {
            w = 2240;
            h = 1400;
            scale = 2;
            position_w = 1600;
            position_h = 500;
            # position_h = toString (builtins.fromJSON msk.h - 700); # builtins.fromJSON makes int from str
          };
        in
        {
          # monitor msk
          # "Shenzhen KTC Technology Group H27S17 0x00000001" = {
          "DP-1" = {
            mode = "${toString msk.w}x${toString msk.h}@164.998Hz";
            scale = "${toString msk.scale}";
            scale_filter = "smart";
            adaptive_sync = "true"; # always off at monitor (but there is too...?)
            render_bit_depth = "10"; # 6, 8, 10. Maybe flickings bc of 10 and 165Hz
            position = "${toString msk.position_w} ${toString msk.position_h}"; # left position
            color_profile = "icc /home/user/nix/devices/screens/msk_fast.icc";
          };

          # lenovo laptop
          "eDP-1" = {
            mode = "${toString lenovo.w}x${toString lenovo.h}@60.002Hz";
            scale = "${toString lenovo.scale}";
            adaptive_sync = "true";
            render_bit_depth = "8"; # 6, 8, 10
            position = "${toString lenovo.position_w} ${toString lenovo.position_h}"; # laptop position for msk
            color_profile = "icc /home/user/nix/devices/screens/lenovo_slow.icc";
          };

          # monitor gg
          "Acer Technologies Acer A231H LQT0W0084320" = {
            mode = "${toString gg.w}x${toString gg.h}@60Hz";
            scale = "${toString gg.scale}";
            position = "${toString gg.position_w} ${toString gg.position_h}"; # left position
            # scale_filter = "linear";
            # adaptive_sync = "enable";
            # render_bit_depth = "10"; # 6, 8, 10
          };
        };

      input = {
        "type:touchpad" = lib.mkForce {
          drag = "disabled";
          drag_lock = "disabled";
          natural_scroll = "enabled"; # enabled is good for lenovo
          tap = "enabled";
          click_method = "button_areas";
        };
      };

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "eDP-1"; # lenovo screen
        }
        {
          workspace = "2";
          output = "eDP-1"; # lenovo screen
        }
        {
          workspace = "3";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
        {
          workspace = "4";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
        {
          workspace = "5";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
        {
          workspace = "6";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
        {
          workspace = "7";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
        {
          workspace = "8";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
        {
          workspace = "9";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
        {
          workspace = "10";
          output = [ "DP-1" "DP-2" "HDMI-A-1" ];
        }
      ];
    }; # config 

    # darktable rusticl support
    extraSessionCommands = ''
      export RUSTICL_ENABLE=radeonsi
    '';
  };
}
