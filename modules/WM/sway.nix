{ pkgs, config, lib, ... }: {
  imports = [
    (import ./waybar.nix {
      inherit config lib;
      MY_DE = "sway";
    })
    ./mako.nix
    ./fuzzel.nix
    ./swaylock.nix
    ./swayidle.nix
    # ./swaywsr.nix
    ./sworkstyle.nix
  ];

  home.packages = with pkgs; [
    autotiling-rs
    brightnessctl
    swaybg
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste
    jq # json parser for some scripts
    nodejs # for run javascript
    vulkan-validation-layers
  ];

  wayland.windowManager.sway = with config.lib.stylix.colors; {
    enable = true;
    # package = pkgs.unstable.sway;
    checkConfig = false; # false because bug with icc profile
    xwayland = true;
    # wrapperFeatures.gtk = true; # gtk apps support

    extraConfig = ''
      popup_during_fullscreen smart
      titlebar_border_thickness 3
      floating_minimum_size 500 x 450
    '';

    config = rec {
      focus = {
        followMouse = "yes";
        mouseWarping = true;
        wrapping = "yes";
        newWindow = "urgent"; # no autofocus on new windows
      };

      modifier = "Mod4";
      # terminal = "${pkgs.kitty}/bin/kitty --single-instance";
      terminal = "${pkgs.foot}/bin/foot";
      menu = "${pkgs.fuzzel}/bin/fuzzel -l 16";
      bars = [{ command = "waybar"; }];
      workspaceAutoBackAndForth = true;

      startup = [
        { command = "bluetooth off"; }
        { command = "autotiling-rs"; }
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.udiskie}/bin/udiskie -a"; }
        { command = "wl-paste -t text --watch clipman store --no-persist"; }
        { command = "exec bash $HOME/nix/scripts/swayidle.sh"; }
        {
          # command = "pkill sworkstyle; sleep 5; ${pkgs.swayest-workstyle}/bin/sworkstyle -d &> /tmp/sworkstyle.log";
          command = "${pkgs.swayest-workstyle}/bin/sworkstyle -d";
          always = true;
        }
      ];

      gaps = {
        outer = 0;
        inner = 0;
        smartGaps = false;
        smartBorders = "on";
      };

      window = {
        border = lib.mkForce 4;
        titlebar = false;
        commands = [
          {
            criteria.app_id = "kitty";
            command = "title_format \"kitty: %title\"";
          }
          # {
          #   criteria.app_id = "org.telegram.desktop";
          #   command = "move container to workspace number 1";
          # }
          # {
          #   criteria.app_id = "com.ayugram.desktop";
          #   command = "move container to workspace number 1";
          # }
          {
            criteria.class = "^[Ss]team.*$";
            command = "move container to workspace number 9";
          }
          {
            criteria.class = "^[Ss]team_app_.*$";
            command = "move container to workspace number 10";
          }
        ];
      };

      # swaymsg -t get_tree - show window's app_id and class
      floating.criteria = [
        { title = "Steam - Update News"; }
        # { title = "Media viewer"; } # telegram
        # { title = "TelegramDesktop"; }
        { app_id = "rg.pulseaudio.pavucontrol"; }
        { app_id = "org.kde.kdeconnect.sms"; }
        # {title = "pulsemixer";} # tailing bug
        { app_id = "floating_yazi"; }
        # {app_id = "floating_nmtui";} # too small window
      ];

      colors =
        let
          # default_color = "#${base02}"; # no focus
          default_color = "#${base01}"; # no focus
          focused_color = "#${base0D}";
          indicator_color = "#${base09}";
          attenction_color = "#${base0D}";
        in
        lib.mkForce {
          focused = {
            text = "#${base00}"; # tab header on creation
            background = attenction_color; # tab header on creation
            border = attenction_color; # tab header on creation
            childBorder = focused_color; # own border color
            indicator = indicator_color; # next window position indicator
          };
          focusedInactive = {
            text = "#${base00}"; # selected tab header
            background = focused_color; # selected tab header
            border = focused_color; # selected tab header
            childBorder = default_color; # default border
            indicator = default_color; # default border
          };
          unfocused = {
            text = "#${base05}"; # unselected tab header
            background = default_color; # unselected tab header
            border = default_color; # unselected tab header
            childBorder = default_color; # ?
            indicator = default_color; # ?
          };
          urgent = {
            text = "#${base05}";
            background = default_color;
            border = default_color;
            childBorder = default_color;
            indicator = default_color;
          };
          placeholder = {
            text = "#${base05}";
            background = "#${base00}";
            border = "#${base00}";
            childBorder = "#${base00}";
            indicator = "#${base00}";
          };
        };

      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:win_space_toggle";
          repeat_delay = "250";
          repeat_rate = "45";
        };
        "type:touchpad" = {
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
        "${modifier}+n" = "exec nautilus";
        "${modifier}+y" = "exec ${terminal} --hold $HOME/nix/scripts/y.fish";

        # broswer
        # export QT_QPA_PLATFORM=xcb for color fix
        "${modifier}+b" = "exec export QT_WAYLAND_DISABLE_WINDOWDECORATION=0 && exec $BROWSER";
        "${modifier}+Shift+B" = "exec export QT_WAYLAND_DISABLE_WINDOWDECORATION=0 && exec proxychains4 qutebrowser --desktop-file-name vpn_qutebrowser --set window.title_format \"[VPN] {perc}{current_title}{title_sep}qutebrowser\"";

        "${modifier}+t" = "exec AyuGram || exec Telegram"; # telegram
        "F10" = "exec swaymsg input 'type:keyboard' xkb_switch_layout 0 && exec swaylock"; # screen locker

        # ---------------
        # cmus control
        # ---------------
        "F1" = "exec cmus-remote -r"; # play pRev
        "F2" = "exec cmus-remote -u"; # pause/play
        "F3" = "exec cmus-remote -n"; # play next

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
        "XF86AudioRaiseVolume" = "exec bash $HOME/nix/scripts/volume.sh 5%+";
        "XF86AudioLowerVolume" = "exec bash $HOME/nix/scripts/volume.sh 5%-";
        "Ctrl+j" = "exec bash $HOME/nix/scripts/volume.sh 5%+";
        "Ctrl+k" = "exec bash $HOME/nix/scripts/volume.sh 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

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

        "${modifier}+Alt+f" = "focus mode_toggle"; # floating and tiled layers

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
        "${modifier}+Shift+j" = "workspace next";
        "${modifier}+Shift+k" = "workspace prev";
        # "${modifier}+Shift+j" = "exec bash $HOME/nix/scripts/sway_workspace.sh next";
        # "${modifier}+Shift+k" = "exec bash $HOME/nix/scripts/sway_workspace.sh prev";

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
      export QT_QPA_PLATFORM=wayland
      export QT_SCALE_FACTOR=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=0
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SDL_VIDEODRIVER=wayland
      export MOZ_ENABLE_WAYLAND=1
      export EDITOR=vi
      export TERMINAL=foot
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      export CLUTTER_BACKEND=wayland
      export GDK_BACKEND=wayland,x11,*
      export GDK_DPI_SCALE=1
      export GDK_SCALE=1
      export MOZ_USE_XINPUT2=1
      export NIXOS_OZONE_WL=1
    '';
    # export _JAVA_AWT_WM_NONREPARENTING=1
  };

}
