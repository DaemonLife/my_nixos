{ pkgs, config, lib, ... }:
let
  execPref = "uwsm app -- ";
  # execPref = ""; # if you don't use UWSM
in
{

  imports = [
    (import ./waybar.nix {
      inherit config lib;
      MY_DE = "hyprland";
    })
    ./mako.nix
    ./fuzzel.nix
    ./swaylock.nix
    ./swayidle.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    grimblast # screenshot tool
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = pkgs.unstable.hyprland;
    systemd.enable = false; # false for UWSM
  };

  wayland.windowManager.hyprland.settings = with config.lib.stylix.colors; {
    "$mod" = "SUPER";
    "$terminal" = "kitty";
    # "$filemanager" = "nautilus -w";
    "$filemanager" = "thunar";
    "$menu" = "fuzzel -l 10";
    "$browser" = "$BROWSER";

    exec-once = [
      "${execPref}pactl set-source-mute @DEFAULT_SOURCE@ on" # mic off
      "${execPref}bluetooth off"
      "${execPref}waybar"
      "${execPref}mako"
      "${execPref}udiskie -a"
      "${execPref}swayidle -w timeout 540 'hyprctl dispatch dpms off' timeout 600 'hyprctl keyword input:kb_layout us,ru && ${execPref}swaylock' resume 'sleep 1 && hyprctl dispatch dpms on'"
    ];

    exec = [
      # maze generator
      "bash $HOME/nix/scripts/maze/run.sh ${base00} ${base02} ${base08} ${base09} ${base0A} ${base0B} ${base0C} ${base0D} ${base0E} ${base0F}"
      # "swaybg -i $HOME/nix/scripts/maze/maze.png"
    ];

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

      touchpad = {
        disable_while_typing = true;
        tap-and-drag = false;
        drag_lock = false;
        natural_scroll = true; # natural mean idiotic
      };
    };

    cursor = {
      # default_monitor = "";
    };

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };

    general = {
      border_size = 4;
      # extend_border_grab_area = 25;
      "col.active_border" = lib.mkForce "rgba(${base0D}ff)";
      "col.inactive_border" = lib.mkForce "rgba(${base03}ff)";
      layout = "dwindle";
      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;
    };

    # disable borders if one window
    workspace = [
      "w[tv1], gapsout:0, gapsin:0"
      "f[1], gapsout:0, gapsin:0"
    ];
    windowrulev2 = [
      "noanim,class:^(.*)$" # testin
      "bordersize 0, floating:0, onworkspace:w[tv1]"
      "rounding 0, floating:0, onworkspace:w[tv1]"
      "bordersize 0, floating:0, onworkspace:f[1]"
      "rounding 0, floating:0, onworkspace:f[1]"
    ];

    misc = {
      vfr = true; # always true!
      vrr = true;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      animate_manual_resizes = false;
      mouse_move_focuses_monitor = true;
      initial_workspace_tracking = 2;
      disable_autoreload = true; # for save battery

      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      enable_swallow = true;
      swallow_regex =
        [ "*kitty*" ];

    };

    # Scale options
    xwayland = {
      force_zero_scaling = true;
    };

    decoration = {
      rounding = 0;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      blur.enabled = false;
      shadow.enabled = false;
    };

    animations = {
      enabled = false;
      # bezier = [
      #   "wind, 0.05, 0.9, 0.1, 1.05"
      #   "winIn, 0.1, 1.1, 0.1, 1.1"
      #   "winOut, 0.3, -0.3, 0, 1"
      #   "liner, 1, 1, 1, 1"
      # ];

      # animation = [
      #   "windows, 1, 6, wind, slide"
      #   "windowsIn, 1, 6, winIn, slide"
      #   "windowsOut, 1, 5, winOut, slide"
      #   "windowsMove, 1, 5, wind, slide"
      #   "border, 1, 1, liner"
      #   "borderangle, 1, 30, liner, loop"
      #   "fade, 1, 10, default"
      #   "workspaces, 1, 5, wind"
      # ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true; # you probably want this
      smart_split = false;
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_distance = 200;
      workspace_swipe_cancel_ratio = "0.05";
    };

    bindm = [
      # Window mouse control
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod, ALT_L, resizewindow"
      # "$mod ALT, mouse:272, resizewindow"
    ];

    bindl = [
      ", switch:Lid Switch, exec, swaylock && hyprctl keyword input:kb_layout us,ru"
      # ",switch:off:Lid Switch, exec, hyprctl keyword input:kb_layout us,ru && swaylock && sleep 1 && hyprctl dispatch dpms off"
      # ",switch:on:Lid Switch, exec, sleep 1 && hyprctl dispatch dpms on"
    ];

    # for long pressed
    binde = [
      # window resize
      "$mod SHIFT, l, resizeactive, 10 0"
      "$mod SHIFT, h, resizeactive, -10 0"
      "$mod SHIFT, k, resizeactive, 0 -10"
      "$mod SHIFT, j, resizeactive, 0 10"

      # Brightness
      ", XF86MonBrightnessUp, exec, ${execPref}brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, ${execPref}brightnessctl set 5%-"
      "Control_L, h, exec, ${execPref}brightnessctl set 5%-"
      "Control_L, l, exec, ${execPref}brightnessctl set 5%+"

      # Audio control
      ", XF86AudioRaiseVolume, exec, ${execPref}amixer sset 'Master' 5%+"
      ", XF86AudioLowerVolume, exec, ${execPref}amixer sset 'Master' 5%-"
      "Control_L, j, exec, ${execPref}amixer sset 'Master' 5%+"
      "Control_L, k, exec, ${execPref}amixer sset 'Master' 5%-"
      ", XF86AudioMute, exec, ${execPref}amixer set Master toggle"
      ", XF86AudioMicMute, exec, ${execPref}amixer sset Capture toggle"
    ];

    # for one press
    bind =
      [
        # Run programs
        "$mod, RETURN, exec, ${execPref}$terminal"
        "$mod, RETURN, exec, ${execPref}hyprctl keyword input:kb_layout us,ru"
        "$mod, A, exec, ${execPref}hyprctl keyword input:kb_layout us,ru && ${execPref}$menu"
        "$mod, N, exec, ${execPref}$filemanager"
        "$mod, y, exec, ${execPref}$terminal --hold $HOME/nix/scripts/y.fish"
        "$mod, B, exec, ${execPref}$browser"
        "$mod SHIFT, B, exec, ${execPref}proxychains4 $browser --set window.title_format [VPN]\\ {perc}{current_title}{title_sep}qutebrowser"
        "$mod, T, exec, ${execPref}telegram-desktop"
        # "$mod, O, exit"

        # Windows control
        "$mod, q, killactive"
        "$mod, v, togglefloating"
        # "$mod, P, pseudo"
        "$mod, s, togglesplit"
        # "$mod, g, togglegroup"
        # "$mod, tab, changegroupactive"
        "$mod, f, fullscreen"
        "$mod, Tab, cyclenext"
        "$mod, Tab, bringactivetotop"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move window
        "$mod Control_L, left, movewindow, l"
        "$mod Control_L, right, movewindow, r"
        "$mod Control_L, up, movewindow, u"
        "$mod Control_L, down, movewindow, d"
        "$mod Control_L, h, movewindow, l"
        "$mod Control_L, l, movewindow, r"
        "$mod Control_L, k, movewindow, u"
        "$mod Control_L, j, movewindow, d"

        # Workspace
        "SHIFT Alt_L, RIGHT, workspace, +1"
        "SHIFT Alt_L, LEFT, workspace, -1"
        "SHIFT Alt_L, l, workspace, +1"
        "SHIFT Alt_L, h, workspace, -1"
        "SHIFT Alt_L, j, workspace, +1"
        "SHIFT Alt_L, k, workspace, -1"
        "SHIFT Alt_L, mouse_up, workspace, +1"
        "SHIFT Alt_L, mouse_down, workspace, -1"

        # Lock screen
        ", F10, exec, ${execPref}hyprctl keyword input:kb_layout us,ru && ${execPref}swaylock"

        # Screenshot
        "SUPER_SHIFT, s, exec, ${execPref}grimblast copysave area"
        " , PRINT, exec, ${execPref}grimblast copysave output"

      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (
          builtins.genList
            (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod Control_L, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            ) 10
        )
      );

  };

  # HYPRLAND VARIABLES

  # export QT_QPA_PLATFORM=wayland;xcb # color error with wayland
  # export QT_QPA_PLATFORMTHEME=qt6ct
  xdg.configFile."uwsm/env".text = ''
    export XDG_SESSION_TYPE=wayland

    export CLUTTER_BACKEND=wayland

    export SDL_VIDEODRIVER=wayland,x11

    export GDK_BACKEND=wayland,x11,*
    export GDK_DPI_SCALE=1
    export GDK_SCALE=1

    export QT_QPA_PLATFORM=wayland;xcb
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    export MOZ_ENABLE_WAYLAND=1
    export MOZ_USE_XINPUT2=1

    export TERMINAL=kitty

    export XCURSOR_SIZE=24
    export XCURSOR_THEME=Bibata-Modern-Ice

    export NIXOS_OZONE_WL=1
  '';

  xdg.configFile."uwsm/env-hyprland".text = ''
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
  '';

}
