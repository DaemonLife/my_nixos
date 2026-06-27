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
  ];

  home.packages = with pkgs; [
    brightnessctl
    grim # screenshot
    slurp # area for screenshot
    fsel
    wl-clipboard # wayland clipboard
    wl-clip-persist # persist wayland clipboard
  ];

  # ------------------------
  # hyprland
  # ------------------------
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
        # gpd 3
        {
          output = "DSI-1";
          mode = "preferred";
          position = "auto-left";
          scale = 1.87500;
          transform = 3;
        }
      ];

      config = {
        general = {
          gaps_in = 0;
          gaps_out = 0;
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
          # scroll_factor = 1.2; # lenovo

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
      };

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
        {_args = [(lib.generators.mkLuaInline ''mod .. " + SHIFT + e"'') (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + f"'') (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + mouse:272"'') (lib.generators.mkLuaInline "hl.dsp.window.drag()") {mouse = true;}];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + mouse:273"'') (lib.generators.mkLuaInline "hl.dsp.window.resize()") {mouse = true;}];}

        # run programs
        {_args = [(lib.generators.mkLuaInline ''mod .. " + b"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd(browser)'')];}
        {_args = [(lib.generators.mkLuaInline ''mod .. " + SHIFT + b"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd('proxychains4 ' .. browser)'')];}
      ];
    };

    extraConfig = ''
      local mainMod = "SUPER" -- Sets "Windows" key as main modifier

      -- -------------
      -- AUTOSTART
      -- -------------

      hl.on("hyprland.start", function ()
        hl.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ on")
        hl.exec_cmd("waybar")
        hl.exec_cmd("mako")
        hl.exec_cmd("udiskie -a")
      end)

      -- -------------
      -- PROGRAMS
      -- -------------

      hl.bind(mainMod .. " + return", hl.dsp.exec_cmd('hyprctl switchxkblayout all 0; foot'))
      hl.bind(mainMod .. " + a", hl.dsp.exec_cmd('hyprctl switchxkblayout all 0; foot bash -c "fsel -d"'))
      hl.bind(mainMod .. " + d", hl.dsp.exec_cmd('hyprctl switchxkblayout all 0; foot bash -c "nnn -C"'))
      hl.bind(mainMod .. " + D", hl.dsp.exec_cmd('bash $HOME/nix/scripts/run_darktable.sh'))

      -- -------------
      -- KEYS
      -- -------------

      -- Screenshot
      hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy && wl-paste > $HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H:%M:%S).png'))
      hl.bind(mainMod .. " + s", hl.dsp.exec_cmd('grim - | wl-copy && wl-paste > $HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H:%M:%S).png'))

      -- Window focus move
      hl.bind(mainMod .. " + h",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + k",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + j",  hl.dsp.focus({ direction = "down" }))

      -- Window move
      hl.bind(mainMod .. " + SHIFT + h",  hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + k",    hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + j",  hl.dsp.window.move({ direction = "down" }))
      for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- Window resize
      hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true }, { description = "Increase window width with keyboard" })
      hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true }, { description = "Reduce window width with keyboard" })
      hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true }, { description = "Increase window height with keyboard" })
      hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true }, { description = "Reduce window height with keyboard" })

      -- Scroll through existing workspaces
      hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + n", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + SHIFT + n",   hl.dsp.focus({ workspace = "e-1" }))

      -- Split toggle
      hl.bind(mainMod .. " + e", hl.dsp.layout("togglesplit"))    -- dwindle only

      -- Laptop multimedia keys for volume and LCD brightness
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
      hl.bind(mainMod .. " + ALT + j", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind(mainMod .. " + ALT + k", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
      hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
      hl.bind(mainMod .. " + ALT + l",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
      hl.bind(mainMod .. " + ALT + h",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
      hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

      -- Lock
      hl.bind("F10",  hl.dsp.exec_cmd("pidof hyprlock || hyprctl switchxkblayout all 0; hyprlock"))

      -- Laptop closing and opening
      -- Trigger when the switch is toggled
      hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("pidof hyprlock || hyprctl switchxkblayout all 0; hyprlock"), { locked = true })
      -- Trigger when the switch is turning on.
      hl.bind("switch:on:Lid Switch", hl.dsp.dpms({ action = "disable" }), { locked = true })
      -- Trigger when the switch is turning off.
      hl.bind("switch:off:Lid Switch", hl.dsp.dpms({ action = "enable" }), { locked = true })

      -- Other
      hl.bind(mainMod .. " + u",  hl.dsp.exec_cmd("hyprctl switchxkblayout all 0"),   { locked = true })
      hl.bind(mainMod .. " + r",  hl.dsp.exec_cmd("hyprctl switchxkblayout all 1"),   { locked = true })

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

  # ------------------------
  # wallpaper
  # ------------------------
  services = {
    hyprpaper = {
      enable = true;
      settings.wallpaper = [
        {
          monitor = "";
          path = "/home/user/Pictures/gowall/bg.png";
        }
      ];
    };
  };

  # ------------------------
  # hypridle and lock
  # ------------------------
  programs.hyprlock = {
    enable = true;
    extraConfig = with config.lib.stylix.colors; ''
      general {
        no_fade_in = true
        no_fade_out = true
        disable_loading_bar = false
        hide_cursor = true
        immediate_render = true
      }
      animations {
        enabled = false
      }
      background {
        monitor =
        # path = /home/user/Pictures/gowall/bg.png
        # path = screenshot
        color = rgb(${base00})
        blur_passes = 0
        blur_size = 0
      }
      # TIME
      label {
          monitor =
          text = $TIME
          color = rgb(${base05})
          font_size = 200
          # font_family = JetBrains Mono Nerd Font Mono ExtraBold
          position = 0, 230
          halign = center
          valign = center
      }
    '';
  };

  services.hypridle.enable = true;
  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprctl switchxkblayout all 0; hyprlock                                     # avoid starting multiple hyprlock instances.
        before_sleep_cmd = hyprctl switchxkblayout all 0; loginctl lock-session                                  # lock before suspend.
        after_sleep_cmd = hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'  # to avoid having to press a key twice to turn on the display.
    }
    listener {
        timeout = 500                                # 2.5min.
        on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = brightnessctl -r                 # monitor backlight restore.
    }
    listener {
        timeout = 600                                 # 5min
        on-timeout = loginctl lock-session            # lock screen when timeout has passed
    }
    listener {
        timeout = 610                                                                                  # 5.5min
        on-timeout = hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'                            # screen off when timeout has passed
        on-resume = hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' && brightnessctl -r          # screen on when activity is detected after timeout has fired.
    }
    listener {
        timeout = 1810
        on-timeout = systemctl hibernate
    }
  '';
}
