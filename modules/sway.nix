{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    (import ./waybar.nix {
      inherit config lib;
      MY_DE = "sway";
    })
    ./mako.nix
    ./fuzzel.nix
    ./swaylock.nix
    ./swayidle.nix
  ];

  home.packages = with pkgs; [
    autotiling-rs
    brightnessctl
    swaybg
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste
  ];

  wayland.windowManager.sway = with config.lib.stylix.colors; {
    enable = true;
    # package = pkgs.unstable.sway;
    checkConfig = false; # false because bug with icc profile
    xwayland = true;
    wrapperFeatures.gtk = true; # gtk apps support

    extraConfig = ''
      focus_on_window_activation focus
      titlebar_border_thickness 4
    '';

    config = rec {
      focus = {
        followMouse = "yes";
        mouseWarping = true;
        wrapping = "yes";
      };

      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty --single-instance";
      menu = "${pkgs.fuzzel}/bin/fuzzel -l 10";
      bars = [{command = "waybar";}];
      workspaceAutoBackAndForth = true;

      startup = [
        {command = "bluetooth off";}
        {command = "autotiling-rs";}
        {command = "${pkgs.mako}/bin/mako";}
        {command = "${pkgs.udiskie}/bin/udiskie -a";}
        {command = "wl-paste -t text --watch clipman store --no-persist";}
        {
          command = "bash $HOME/nix/scripts/maze/run.sh '000000' ${base08} ${base09} ${base0A} ${base0B} ${base0C} ${base0D} ${base0E} ${base0F}";
        }
        {
          command = ''
            swayidle -w \
            timeout 600 'brightnessctl -s; brightnessctl set 0%' \
            timeout 610 'swaymsg "output * dpms off"' \
            timeout 615 'swaymsg input "type:keyboard xkb_switch_layout 0"; swaylock -f' \
            resume 'swaymsg "output * dpms on"; brightnessctl -r' \
            before-sleep 'swaylock -f'
          '';
        }
      ];

      gaps = {
        outer = 2;
        inner = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      window = {
        border = lib.mkForce 4;
        titlebar = false;
        commands = [
          {
            command = "title_format \"kitty: %title\"";
            criteria.app_id = "kitty";
          }
        ];
      };

      floating.criteria = [
        {
          title = "Steam - Update News";
        }
        {
          class = "Pavucontrol";
        }
      ];

      colors = lib.mkForce {
        focused = {
          text = "#${base05}";
          background = "#${base00}";
          border = "#${base0D}";
          childBorder = "#${base0D}";
          indicator = "#${base0E}";
        };
        focusedInactive = {
          text = "#${base05}";
          background = "#${base00}";
          border = "#${base01}";
          childBorder = "#${base00}";
          indicator = "#${base00}";
        };
        unfocused = {
          text = "#${base05}";
          background = "#${base00}";
          border = "#${base01}";
          childBorder = "#${base00}";
          indicator = "#${base00}";
        };
        urgent = {
          text = "#${base05}";
          background = "#${base00}";
          border = "#${base01}";
          childBorder = "#${base00}";
          indicator = "#${base00}";
        };
        placeholder = {
          text = "#${base05}";
          background = "#${base00}";
          border = "#${base01}";
          childBorder = "#${base00}";
          indicator = "#${base00}";
        };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:win_space_toggle";
          repeat_delay = "300";
          repeat_rate = "60";
        };
        "type:touchpad" = {
          natural_scroll = "enabled"; # enabled is good for lenovo
          tap = "enabled";
          click_method = "button_areas";
        };
      };

      bindkeysToCode = true;
      keybindings = {
        # ---------------
        # Start programs
        # ---------------

        # terminal
        "${modifier}+Return" = ''
          exec swaymsg input "type:keyboard" xkb_switch_layout 0 && exec ${terminal}
        '';

        # menu
        "${modifier}+a" = ''exec swaymsg input "type:keyboard" xkb_switch_layout 0 && exec ${menu}'';

        # file manager
        "${modifier}+n" = "exec thunar";
        "${modifier}+y" = "exec ${terminal} --hold $HOME/nix/scripts/y.fish";

        # broswer
        "${modifier}+b" = "exec $BROWSER";
        "${modifier}+Shift+B" = "exec proxychains4 $BROWSER --set window.title_format \"[VPN] {perc}{current_title}{title_sep}qutebrowser\"";

        "${modifier}+t" = "exec telegram-desktop"; # telegram
        "F10" = "exec swaylock"; # screen locker

        # ---------------
        # Window control
        # ---------------

        "${modifier}+q" = "kill";
        "${modifier}+f" = "fullscreen";
        "${modifier}+Shift+f" = "floating toggle";
        "${modifier}+r" = "mode resize";
        "${modifier}+e" = "layout toggle splith splitv tabbed";
        # "${modifier}+t" = "layout toggle tabbed splith";

        # ---------------
        # System control
        # ---------------

        "${modifier}+Shift+r" = "reload"; # config reload

        # Brightness control
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "Ctrl+l" = "exec brightnessctl set +5%";
        "Ctrl+h" = "exec brightnessctl set 5%-";

        # Audio
        "XF86AudioRaiseVolume" = "exec bash $HOME/nix/scripts/volume.sh 5";
        "XF86AudioLowerVolume" = "exec bash $HOME/nix/scripts/volume.sh -5";
        "Ctrl+j" = "exec bash $HOME/nix/scripts/volume.sh 5";
        "Ctrl+k" = "exec bash $HOME/nix/scripts/volume.sh -5";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # Screenshot
        "${modifier}+Shift+s" = "exec bash $HOME/nix/scripts/screenshot.sh region";
        "PRINT" = "exec bash $HOME/nix/scripts/screenshot.sh output";

        # Moving around:
        "${modifier}+Left" = "focus left";
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";

        "${modifier}+h" = "focus left";
        "${modifier}+l" = "focus right";
        "${modifier}+k" = "focus up";
        "${modifier}+j" = "focus down";

        "${modifier}+Ctrl+h" = "move left";
        "${modifier}+Ctrl+l" = "move right";
        "${modifier}+Ctrl+k" = "move up";
        "${modifier}+Ctrl+j" = "move down";

        # Switch to workspace
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        "Alt+Shift+j" = "workspace next";
        "Alt+Shift+k" = "workspace prev";
        "Alt+Shift+l" = "workspace next";
        "Alt+Shift+h" = "workspace prev";

        # Move focused container to workspace
        "${modifier}+Ctrl+1" = "move container to workspace number 1";
        "${modifier}+Ctrl+2" = "move container to workspace number 2";
        "${modifier}+Ctrl+3" = "move container to workspace number 3";
        "${modifier}+Ctrl+4" = "move container to workspace number 4";
        "${modifier}+Ctrl+5" = "move container to workspace number 5";
        "${modifier}+Ctrl+6" = "move container to workspace number 6";
        "${modifier}+Ctrl+7" = "move container to workspace number 7";
        "${modifier}+Ctrl+8" = "move container to workspace number 8";
        "${modifier}+Ctrl+9" = "move container to workspace number 9";
        "${modifier}+Ctrl+0" = "move container to workspace number 10";
      };

      modes = {
        resize = {
          "h" = "resize grow left 10px";
          "l" = "resize grow right 10px";
          "Shift+h" = "resize grow left -10px";
          "Shift+l" = "resize grow right -10px";

          "j" = "resize grow down 10px";
          "k" = "resize grow up 10px";
          "Shift+j" = "resize grow down -10px";
          "Shift+k" = "resize grow up -10px";

          # Return to normal mode
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # export _JAVA_AWT_WM_NONREPARENTING=1
      export XDG_CURRENT_DESKTOP=sway
      export MOZ_ENABLE_WAYLAND=1
      export TERMINAL=kitty
      export WLR_RENDERER=vulkan
    '';
  };
}
