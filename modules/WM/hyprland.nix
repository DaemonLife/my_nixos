{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    (import ./waybar.nix {
      inherit config lib;
      MY_DE = "hyprland";
    })
    ./mako.nix
    ./swaylock.nix
    ./swayidle.nix
    ./sworkstyle.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    grimblast # screenshot tool
    swaybg
    fsel
    wl-clipboard # wayland clipboard
    wl-clip-persist # persist wayland clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = lib.mkForce "lua";

    settings = with config.lib.stylix.colors; {
      mod = {
        _var = "SUPER";
      };

      startupcommands = {
        _var = [
          "pactl set-source-mute @DEFAULT_SOURCE@ on" # mic off
          "swaybg -i $HOME/Picture/gowall/bg.png"
          "waybar"
          "mako"
          "udiskie -a"
          "wl-clip-persist --clipboard regular"
          "swayidle -w timeout 540 'hyprctl dispatch dpms off' timeout 600 'hyprctl keyword input:kb_layout us,ru && swaylock' resume 'sleep 1 && hyprctl dispatch dpms on'"
        ];
      };

      monitor = [
        {
          output = "eDP-1";
          mode = "highres";
          position = "auto";
          scale = 1;
        }
        {
          output = "desc:Acer Technologies Acer A231H LQT0W0084320";
          position = "auto-right";
          mode = "highres";
          scale = 1;
        }
      ];

      config = {
        general = {
          gaps_in = 4;
          gaps_out = 4;
          border_size = 4;
          col = {
            active_border = lib.mkForce "rgba(${base0D}ff)";
            inactive_border = lib.mkForce "rgba(${base03}ff)";
          };
          resize_on_border = true;
          # layout = "dwindle";
          # layout = "scrolling";
          allow_tearing = false;
        };

        decoration = {
          rounding = 0;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow.enabled = false;
          blur.enabled = false;
        };

        xwayland.force_zero_scaling = true;

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        input = {
          # keyboard
          kb_layout = "us,ru";
          kb_options = "grp:win_space_toggle";
          repeat_rate = 45; # in one second
          repeat_delay = 190;

          # mouse or hamster
          accel_profile = "adaptive";
          force_no_accel = false;
          follow_mouse = 1; # window focus follow cursor
          natural_scroll = false; # natural mean idiotic
          sensitivity = -0.2; # from -1.0 to 1.0
          scroll_factor = "0.5";

          # touchpad = {
          # disable_while_typing = true;
          # tap-and-drag = false;
          # drag_lock = false;
          # natural_scroll = true; # natural mean idiotic??????
          # };
        };

        animations.enabled = false;

        dwindle = {
          preserve_split = true; # you probably want this
          # smart_split = false;
        };
        scrolling = {
          fullscreen_on_one_column = true;
          column_width = 0.48;
          explicit_column_widths = "0.32,0.48,0.64,0.96";
        };
        misc = {
          force_default_wallpaper = 0;
        };
      }; # new config

      env = [
        {
          _args = [
            "XCURSOR_SIZE"
            "24"
          ];
        }
        {
          _args = [
            "HYPRCURSOR_SIZE"
            "24"
          ];
        }
      ];

      bind = [
        {_args = [(lib.generators.mkLuaInline ''mod .. " + return"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("foot")'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + q"'') (lib.generators.mkLuaInline "hl.dsp.window.close()")];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + t"'') (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + f"'') (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + mouse:272"'') (lib.generators.mkLuaInline "hl.dsp.window.drag()") {mouse = true;}];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + mouse:273"'') (lib.generators.mkLuaInline "hl.dsp.window.resize()") {mouse = true;}];}
      ];

      # bindm = [
      #   # Window mouse control
      #   "$mod, mouse:272, movewindow"
      #   "$mod, mouse:273, resizewindow"
      #   "$mod, ALT_L, resizewindow"
      #   # "$mod ALT, mouse:272, resizewindow"
      # ];

      # bindl = [
      #   ", switch:Lid Switch, exec, swaylock && hyprctl keyword input:kb_layout us,ru"
      #   # ",switch:off:Lid Switch, exec, hyprctl keyword input:kb_layout us,ru && swaylock && sleep 1 && hyprctl dispatch dpms off"
      #   # ",switch:on:Lid Switch, exec, sleep 1 && hyprctl dispatch dpms on"
      # ];

      # for long pressed
      # binde = [
      #   # window resize
      #   "$mod SHIFT, l, resizeactive, 10 0"
      #   "$mod SHIFT, h, resizeactive, -10 0"
      #   "$mod SHIFT, k, resizeactive, 0 -10"
      #   "$mod SHIFT, j, resizeactive, 0 10"
      #
      #   # Brightness
      #   ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      #   ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      #   "Control_L, h, exec, brightnessctl set 5%-"
      #   "Control_L, l, exec, brightnessctl set 5%+"
      #
      #   # Audio control
      #   ", XF86AudioRaiseVolume, exec, amixer sset 'Master' 5%+"
      #   ", XF86AudioLowerVolume, exec, amixer sset 'Master' 5%-"
      #   "Control_L, j, exec, amixer sset 'Master' 5%+"
      #   "Control_L, k, exec, amixer sset 'Master' 5%-"
      #   ", XF86AudioMute, exec, amixer set Master toggle"
      #   ", XF86AudioMicMute, exec, amixer sset Capture toggle"
      # ];

      # for one press
      # bind =
      #   [
      #     # Run programs
      #     "$mod, RETURN, exec, $terminal"
      #     "$mod, RETURN, exec, hyprctl keyword input:kb_layout us,ru"
      #     "$mod, A, exec, hyprctl keyword input:kb_layout us,ru && $menu"
      #     "$mod, N, exec, $filemanager"
      #     "$mod, y, exec, $terminal --hold $HOME/nix/scripts/y.sh"
      #     "$mod, B, exec, $browser"
      #     "$mod SHIFT, B, exec, proxychains4 $browser"
      #     # "$mod SHIFT, B, exec, proxychains4 $browser --set window.title_format [VPN]\\ {perc}{current_title}{title_sep}qutebrowser"
      #     "$mod, T, exec, bash -c 'AyuGram || Telegram || flatpak run org.telegram.desktop'"
      #     # "$mod, O, exit"
      #
      #     # Windows control
      #     "$mod, q, killactive"
      #     "$mod, v, togglefloating"
      #     # "$mod, P, pseudo"
      #     # "$mod, s, togglesplit"
      #     # "$mod, g, togglegroup"
      #     # "$mod, tab, changegroupactive"
      #     "$mod, f, fullscreen"
      #     "$mod, Tab, cyclenext"
      #     "$mod, Tab, bringactivetotop"
      #
      #     # Move focus
      #     "$mod, left, movefocus, l"
      #     "$mod, right, movefocus, r"
      #     "$mod, up, movefocus, u"
      #     "$mod, down, movefocus, d"
      #     "$mod, h, movefocus, l"
      #     "$mod, l, movefocus, r"
      #     "$mod, k, movefocus, u"
      #     "$mod, j, movefocus, d"
      #
      #     # Move window
      #     "$mod Control_L, left, movewindow, l"
      #     "$mod Control_L, right, movewindow, r"
      #     "$mod Control_L, up, movewindow, u"
      #     "$mod Control_L, down, movewindow, d"
      #     "$mod Control_L, h, movewindow, l"
      #     "$mod Control_L, l, movewindow, r"
      #     "$mod Control_L, k, movewindow, u"
      #     "$mod Control_L, j, movewindow, d"
      #
      #     # Workspace
      #     "SHIFT Alt_L, RIGHT, workspace, +1"
      #     "SHIFT Alt_L, LEFT, workspace, -1"
      #     "SHIFT Alt_L, l, workspace, +1"
      #     "SHIFT Alt_L, h, workspace, -1"
      #     "SHIFT Alt_L, j, workspace, +1"
      #     "SHIFT Alt_L, k, workspace, -1"
      #     "SHIFT Alt_L, mouse_up, workspace, +1"
      #     "SHIFT Alt_L, mouse_down, workspace, -1"
      #
      #     # Lock screen
      #     ", F10, exec, hyprctl keyword input:kb_layout us,ru && swaylock"
      #
      #     # Screenshot
      #     "SUPER_SHIFT, s, exec, grimblast copysave area"
      #     " , PRINT, exec, grimblast copysave output"
      #   ]
      # ++ (
      #   # workspaces
      #   # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      #   builtins.concatLists (
      #     builtins.genList
      #     (
      #       x: let
      #         ws = let
      #           c = (x + 1) / 10;
      #         in
      #           builtins.toString (x + 1 - (c * 10));
      #       in [
      #         "$mod, ${ws}, workspace, ${toString (x + 1)}"
      #         "$mod Control_L, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
      #       ]
      #     )
      #     10
      #   )
      # );
    };

    # HYPRLAND VARIABLES

    # export QT_QPA_PLATFORM=wayland;xcb # color error with wayland
    # export QT_QPA_PLATFORMTHEME=qt6ct
    # xdg.configFile."uwsm/env".text = ''
    #   export XDG_SESSION_TYPE=wayland
    #   export CLUTTER_BACKEND=wayland
    #   export SDL_VIDEODRIVER=wayland,x11
    #   export GDK_BACKEND=wayland,x11,*
    #   export GDK_DPI_SCALE=1
    #   export GDK_SCALE=1
    #
    #   export QT_QPA_PLATFORM=wayland;xcb
    #   export QT_AUTO_SCREEN_SCALE_FACTOR=1
    #   export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    #
    #   export MOZ_ENABLE_WAYLAND=1
    #   export MOZ_USE_XINPUT2=1
    #
    #   export TERMINAL=foot
    #
    #   export XCURSOR_SIZE=24
    #   export XCURSOR_THEME=Bibata-Modern-Ice
    #
    #   export NIXOS_OZONE_WL=1
    # '';
    #
    # xdg.configFile."uwsm/env-hyprland".text = ''
    #   export XDG_CURRENT_DESKTOP=Hyprland
    #   export XDG_SESSION_DESKTOP=Hyprland
    # '';
  };
}
