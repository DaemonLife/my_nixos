{
  config,
  lib,
  MY_DE,
  ...
}: {
  programs.waybar = with config.lib.stylix.colors;
    lib.mkForce {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          # height = 31;
          modules-left = ["${MY_DE}/workspaces"];
          modules-center = [];
          modules-right = [
            "tray"
            "privacy"
            "${MY_DE}/language"
            "network"
            "bluetooth"
            "idle_inhibitor"
            "battery"
            "pulseaudio"
            "clock"
          ];

          "${MY_DE}/workspaces" = {
            persistent-workspaces = {
              "*" = [2 3 4 5 6];
              "Acer Technologies Acer A231H LQT0W0084320" = [2 3 4 5 6];
              "eDP-1" = [1]; # laptop
            };
            format = " {name}:[{windows}] ";
            format-window-separator = "-";
            on-click = "activate";
            window-rewrite-default = "?";
            window-rewrite = {
              "foot" = "$";
              "librewolf" = "librewolf";
              "mpv" = "mpv";
              "nautilus" = "files";
              "Upscayl" = "upscayl";
              "darktable" = "darktable";
              "Mindustry" = "mindustry";
              "org.kde.kdenlive" = "kdenlive";
              "siril" = "siril";
              "gimp" = "gimp";
              "/^.* - cmus$/" = "cmus";
              "/^man .*$/" = "man";
              "/^btop .*$/" = "btop";
              "/^htop .*$/" = "htop";
              "org.telegram.desktop" = "tg";
              "com.ayugram.desktop" = "tg";
              "org.qutebrowser.qutebrowser" = "qb";
              "org.qbittorrent.qBittorrent" = "torrent";
              "/^.*[Ss]team.*$/" = "steam";
              "/^vi.*$/" = "vi";
              "/^.*Nvim$/" = "vi";
              "/^nvim$/" = "vi";
              "/^y .*$/" = "y";
              "/^rtorrent.*$/" = "rtorrent";
              "/^.*Firefox$/" = "firefox";
              "/^AmneziaVPN$/" = "vpn";
            };
          };

          privacy.modules = [
            {type = "screenshare";}
            {type = "audio-in";}
            # {type = "audio-out";}
          ];

          tray = {
            spacing = 12;
            icon-size = config.stylix.fonts.sizes.terminal;
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "idle";
              deactivated = "idle";
            };
            tooltip = false;
          };

          bluetooth = {
            format = "bt";
            format-alt = "bt";
            format-disabled = "bt";
            format-connected = "bt {status}";
            # interval = 5;
            # format-icons = {
            #   enabled = "bt";
            #   disabled = "bt";
            # };
            on-click = "bluetooth on";
            on-click-right = "bluetooth off";
            tooltip = false;
          };

          "${MY_DE}/language" = {
            format = "{}";
            format-en = "us";
            format-ru = "ru";
            on-click = "exec gnome-calendar";
            tooltip = false;
          };

          "clock" = {
            format = "{:%b-%d %H:%M}";
            on-click = "exec gnome-calendar";
            "tooltip-format" = "<span size='${toString (config.stylix.fonts.sizes.popups - 2)}pt' font='${config.stylix.fonts.monospace.name}'>{calendar}</span>";
            "calendar" = {
              "mode" = "year";
              "mode-mon-col" = 3;
              # "weeks-pos"     = "right";
              "on-scroll" = 1;
              "on-click-right" = "mode";
              "format" = {
                "months" = "<span color='#${base05}'><b>{}</b></span>";
                "weekdays" = "<span color='#${base04}'>{}</span>";
                "weeks" = "<span color='#${base0C}'>W{}</span>";
                "days" = "<span color='#${base03}'>{}</span>";
                "today" = "<span color='#${base08}'><b>{}</b></span>";
              };
            };
            "actions" = {
              "on-click-right" = "mode";
              "on-click-forward" = "tz_down";
              "on-click-backward" = "tz_up";
              "on-scroll-up" = "shift_down";
              "on-scroll-down" = "shift_up";
            };
          };

          battery = {
            states = {
              full = 98;
              good = 80;
              warning = 40;
              critical = 20;
            };
            # interval = 30;
            format = "bat-{capacity}-";
            format-plugged = "bat-{capacity}";
            format-charging = "bat-{capacity}+";
            on-click = "gnome-power-statistics";
            tooltip = false;
          };

          network = {
            format-disabled = "net";
            format-wifi = "net";
            format-ethernet = "net_{ipaddr}/{cidr}";
            format-linked = "net_(No IP)";
            format-disconnected = "net";
            on-click = ''wifi on && $TERMINAL -a "floating_nmtui" sh -c "nmcli dev wifi rescan && nmtui"'';
            on-click-right = "wifi off";
            # interval = 2;
            tooltip = false;
          };

          pulseaudio = {
            format = "{icon}-{volume}{format_source}";
            format-bluetooth = "{icon}-{volume}{format_source}";
            format-bluetooth-muted = "{icon}-{volume}{format_source}";
            format-muted = "mut";
            format-source = " mic";
            format-source-muted = "";
            format-icons = {
              headset = "aux";
              headphone = "aux";
              hands-free = "aux";
              phone = "phone";
              portable = "port";
              car = "vol-buy-a-bicycle";
              default = "vol";
              speaker = "spk";
              hdmi = "hdmi";
            };
            max-volume = 100;
            tooltip-format = "{desc}, {volume}%";
            on-click = "$TERMINAL sh -c 'pulsemixer'"; # or pavucontrol
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; # mic mute
            on-click-middle = "crosspipe";
            scroll-step = 5;
            reverse-scrolling = true;
            tooltip = false;
          };
        };
      };

      style = let
        focus =
          if "${MY_DE}" == "sway"
          then "focused"
          else "active";
      in
        lib.mkAfter ''
            @define-color dark #${base00};
            @define-color gray #${base02};
            @define-color dark-white #${base04};
            @define-color white #${base05};
            @define-color accent #${base0D};
            @define-color green #${base0B};
            @define-color red #${base08};
            @define-color magenta #${base09};
            @define-color yellow #${base0A};

            /* Default setting for all modules */
            * {
              border: none;
              border-radius: 0;
              margin: 0px;
              text-decoration: none;
              font-family: "${config.stylix.fonts.monospace.name}";
              font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
              min-height: 0;
              box-shadow: none;
            }

            /* Default color for modules except workspaces button.active */
            #window, window#waybar, #tray, #language, #network, #bluetooth, #idle_inhibitor, #battery, #pulseaudio, #clock#time, #clock#date, #privacy { color: @white; }

            /* Default padding for some modules */
          #tray, #language, #network, #bluetooth, #idle_inhibitor, #battery, #pulseaudio, #clock, #privacy { padding: 0px 6px 0px 6px; }

            #custom-sep {
              color: @gray;
            }

            #tray {
              padding: 0 5px;
            }

            #language {
              background-color: #${base00};
            }
            #network {
              background-color: #${base00};
            }
            #bluetooth {
              background-color: #${base00};
            }
            #idle_inhibitor {
              background-color: #${base00};
            }
            #pulseaudio {
              background-color: #${base00};
            }
            #battery {
              background-color: #${base00};
            }
            #clock.date {
              background-color: #${base00};
            }
            #clock.time {
              background-color: #${base00};
            }

            #workspaces button {
              font-weight: normal;
              color: @dark-white;
              background-color: #${base00};
              padding-left: 0px;
              padding-right: 0px;
              margin: 0px 0px 0px 0px;
            }
            #workspaces button.empty {
              font-weight: normal;
              color: @gray;
              background-color: #${base00};
              padding-right: 0px;
              padding-left: 0px;
              margin: 0px 0px 0px 0px;
            }
            #workspaces button.${focus} {
              font-weight: normal;
              color: @dark;
              background-color: @accent;
              padding-right: 0px;
              padding-left: 0px;
              margin: 0px 0px 0px 0px;
            }

            window#waybar {
              background-color: @dark;
            }
            #window { padding: 0px 10px 0px 6px; }

            tooltip {
              font-size: ${toString (config.stylix.fonts.sizes.popups)}pt;
              color: @white;
              background-color: @dark;
              border: 4px;
              border-style: solid;
              border-color: @accent;
              font-weight: normal;
              padding: 0px 0px 0px 0px;
              margin: 0px 0px 0px 0px;
            }

            /* on but not connect */
            #network.disconnected { color: @yellow;}
            /* off */
            #network.disabled { color: @gray; }

            #idle_inhibitor.activated { color: @green; }
            #idle_inhibitor.deactivated { color: @gray; }

            #bluetooth { color: @yellow; }
            #bluetooth.disabled { color: @gray; }
            #bluetooth.on { color: @yellow; }
            #bluetooth.off { color: @gray; }
            #bluetooth.connected { color: @green; }

            #pulseaudio.muted { color: @gray; }

            #battery.plugged { color: @green; }
            #battery.charging{
              color: @green;
              animation-name: blink;
              animation-duration: 1.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
            }
            #battery.warning:not(.charging) { color: @yellow; }
            #battery.critical:not(.charging) { color: @red; }
            @keyframes blink { to { color: @gray; } }
        '';
    };
}
