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
  ];

  home.packages = with pkgs; [
    brightnessctl
    grim # screenshot
    slurp # area for screenshot
    swaybg
    fsel
    wl-clipboard # wayland clipboard
    wl-clip-persist # persist wayland clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = lib.mkForce "lua";

    settings = with config.lib.stylix.colors; {
      mod._var = "SUPER";
      terminal._var = "foot";
      browser._var = "librewolf";
      filemanager._var = "nautilus";
      menu._var = ''foot bash -c "fsel -d"'';

      # hyprctl monitors all
      monitor = [
        {
          output = "desc:Lenovo Group Limited 0x9121";
          mode = "highres";
          position = "auto";
          scale = 1.75;
          icc = "/home/user/nix/devices/screens/lenovo_slow.icc";
        }
        {
          output = "desc:Shenzhen KTC Technology Group H27S17 0x00000001";
          mode = "highres";
          position = "auto-left";
          scale = 1.33;
          bitdepth = 10; # 8 (default) or 10
          vrr = 0; # 0 (default) or 1
          supports_hdr = 0; # -1, 0 (auto, default), 1
          icc = "/home/user/nix/devices/screens/msk_fast.icc";
        }
        {
          output = "desc:Acer Technologies Acer A231H LQT0W0084320";
          mode = "highres";
          position = "auto-right";
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
        animations.enabled = false;

        xwayland.force_zero_scaling = true;

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        input = {
          # keyboard
          kb_layout = "us,ru";
          kb_options = "grp:win_space_toggle";
          repeat_rate = 30; # in one second
          repeat_delay = 215;

          # mouse or hamster
          accel_profile = "adaptive";
          force_no_accel = false;
          follow_mouse = 1; # window focus follow cursor
          natural_scroll = false; # natural mean idiotic
          sensitivity = 0.0; # from -1.0 to 1.0
          scroll_factor = 1.2; # lenovo

          touchpad = {
            disable_while_typing = true;
            tap_and_drag = false;
            drag_lock = 0; # fuck this shit
            natural_scroll = true; # TRUE FOR LENOVO TOUCHPAD!!!
            scroll_factor = 0.5; # lenovo
          };
        };

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
        # windows control
        {_args = [(lib.generators.mkLuaInline ''mod .. " + q"'') (lib.generators.mkLuaInline "hl.dsp.window.close()")];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + SHIFT + t"'') (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + f"'') (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + mouse:272"'') (lib.generators.mkLuaInline "hl.dsp.window.drag()") {mouse = true;}];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + mouse:273"'') (lib.generators.mkLuaInline "hl.dsp.window.resize()") {mouse = true;}];}

        # run programs
        {_args = [(lib.generators.mkLuaInline ''mod .. " + return"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd(terminal)'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + a"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd(menu)'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + n"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd(filemanager)'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + b"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd(browser)'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + SHIFT + b"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd('proxychains4 ' .. browser)'')];}
      ];

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
      #     # Lock screen
      #     ", F10, exec, hyprctl keyword input:kb_layout us,ru && swaylock"
      #
      #     # Screenshot
      #     "SUPER_SHIFT, s, exec, grimblast copysave area"
      #     " , PRINT, exec, grimblast copysave output"
      #   ]
    };

    #     "exec wl-clip-persist --clipboard regular"
    extraConfig = ''
      -- AUTOSTART

      hl.on("hyprland.start", function ()
        hl.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ on")
        hl.exec_cmd("swaybg -i $HOME/Picture/gowall/bg.png")
        hl.exec_cmd("waybar")
        hl.exec_cmd("mako")
        hl.exec_cmd("udiskie -a")
        hl.exec_cmd("swayidle -w timeout 540 'hyprctl dispatch dpms off' timeout 600 'hyprctl keyword input:kb_layout us,ru && swaylock' resume 'sleep 1 && hyprctl dispatch dpms on'")
      end)

      -- KEYS

      local mainMod = "SUPER" -- Sets "Windows" key as main modifier

      hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy && wl-paste > $HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H:%M:%S).png'))
      hl.bind(mainMod .. " + s", hl.dsp.exec_cmd('grim - | wl-copy && wl-paste > $HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H:%M:%S).png'))

      -- Window focus move
      hl.bind(mainMod .. " + h",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + k",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + j",  hl.dsp.focus({ direction = "down" }))

      hl.bind(mainMod .. " + SHIFT + h",  hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + k",    hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + j",  hl.dsp.window.move({ direction = "down" }))

      -- Window move
      for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- Scroll through existing workspaces
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + CTRL + j", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + k",   hl.dsp.focus({ workspace = "e-1" }))

      -- Split toggle
      hl.bind(mainMod .. " + t", hl.dsp.layout("togglesplit"))    -- dwindle only

      -- Laptop multimedia keys for volume and LCD brightness
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
      hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

      -- Requires playerctl
      hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

    '';
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
