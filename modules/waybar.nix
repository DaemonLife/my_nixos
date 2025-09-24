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
          height = 28;
          modules-left = [
            "${MY_DE}/workspaces"
            "${MY_DE}/window"
          ];
          modules-center = [];
          modules-right = [
            "tray"
            "${MY_DE}/language"
            "custom/sep"
            "network"
            "custom/sep"
            "bluetooth"
            "custom/sep"
            "idle_inhibitor"
            "custom/sep"
            "battery"
            "custom/sep"
            "pulseaudio"
            "custom/sep"
            "clock#date"
            "custom/sep"
            "clock#time"
          ];

          "${MY_DE}/workspaces" = {
            window-rewrite = {};
            on-click = "activate";
            disable-scroll = true;
            format = "{icon}";
            persistent-workspaces = {
              # workspace and monitors
              "1" = [
                "eDP-1"
                "DSI-1"
              ];
              "2" = [
                "DP-1"
                "HDMI-A-1"
              ];
              "3" = [
                "DP-1"
                "HDMI-A-1"
              ];
              "4" = [
                "DP-1"
                "HDMI-A-1"
              ];
              "5" = [
                "DP-1"
                "HDMI-A-1"
              ];
            };
            format-icons = {
              "1" = 1; # workspace id and icon format
              "2" = 2;
              "3" = 3;
              "4" = 4;
              "5" = 5;
              "6" = 6;
              "7" = 7;
              "8" = 8;
              "9" = 9;
              "10" = 10;
            };
          };

          "${MY_DE}/window" = {
            max-length = 60;
            separate-outputs = true;
            format = {};
            rewrite = {};
          };

          tray.spacing = 10;

          # Modules
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "idle";
              deactivated = "idle";
            };
          };

          "custom/sep" = {
            format = "|";
          };

          bluetooth = {
            format = "{icon}";
            format-alt = "{icon}";
            # interval = 5;
            format-icons = {
              enabled = "bt";
              disabled = "bt";
            };
            tooltip-format = "{}";
            on-click = "bluetooth on";
            on-click-right = "bluetooth off";
          };

          "hyprland/language" = {
            format = "{}";
            format-en = "us";
            format-ru = "ru";
          };

          "clock#time" = {
            format = "{:%H:%M}";
            tooltip = false;
            # exec = ../scripts/timezone.sh;
          };
          "clock#date" = {
            format = "{:%d-%b-%y}";
            on-click = "exec gnome-calendar";
            "tooltip-format" = "<span size='10pt' font='GeistMono Nerd Font Mono'>{calendar}</span>";
            "calendar" = {
              "mode" = "year";
              "mode-mon-col" = 3;
              # "weeks-pos"     = "right";
              "on-scroll" = 1;
              "on-click-right" = "mode";
              "format" = {
                "months" = "<span color='#${base0A}'><b>{}</b></span>";
                "days" = "<span color='#${base05}'><b>{}</b></span>";
                "weeks" = "<span color='#${base0C}'><b>W{}</b></span>";
                "weekdays" = "<span color='#${base0B}'><b>{}</b></span>";
                "today" = "<span color='#${base0E}'><b><u>{}</u></b></span>";
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
              good = 90;
              warning = 35;
              critical = 20;
            };
            # interval = 30;
            format = "bat {capacity}";
            format-plugged = "bat {capacity}";
            format-charging = "bat {capacity}ϟ";
            on-click = "gnome-power-statistics";
          };

          network = {
            format-disabled = "wifi";
            format-wifi = "wifi";
            format-ethernet = " {ipaddr}/{cidr}";
            format-linked = "wifi (No IP)";
            format-disconnected = "wifi";
            on-click = ''wifi on && $TERMINAL --hold sh -c "nmcli dev wifi rescan && nmtui"'';
            on-click-right = "wifi off";
            # interval = 2;
          };

          pulseaudio = {
            # format = "{icon}{format_source}";
            format = "{icon} {volume}{format_source}";
            format-bluetooth = "{icon} {volume}{format_source}";
            format-bluetooth-muted = "{icon} {volume}{format_source}";
            format-muted = "muted";
            format-source = " mic";
            format-source-muted = "";
            format-icons = {
              hands-free = "headset";
              headset = "headset";
              headphone = "headset";
              phone = "phone";
              portable = "portable";
              car = "car";
              speaker = "speaker";
              default = "vol";
              hdmi = "hdmi";
            };
            max-volume = 100;
            tooltip-format = "{desc}, {volume}%";
            on-click = "$TERMINAL sh -c 'pulsemixer'"; # or pavucontrol
            on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            on-click-middle = "helvum";
            scroll-step = 5;
          };
        };
      };

      style = let
        focus =
          if "${MY_DE}" == "sway"
          then "focused"
          else "active";
      in
        #css
        ''
          	@define-color dark #${base00};
          	@define-color gray #${base03};
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
          	  font-family: "Mononoki Nerd Font Regular";
              font-size: 16px;
              min-height: 0;
              box-shadow: none;
          	}

            /* Default color for modules except workspaces button.active */
            #workspaces button, #window, window#waybar, #tray, #language, #network, #bluetooth, #idle_inhibitor, #battery, #pulseaudio, #clock#time, #clock#date { color: @white; }

          	/* Default padding for some modules */
          #tray,	#language, #network, #bluetooth, #idle_inhibitor, #battery, #pulseaudio, #clock { padding: 0px 5px 0px 5px; }

            #custom-sep {
              color: @gray;
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
              padding: 0px 2px 0px 2px;
            }
            #workspaces button.empty {
              font-weight: normal;
              padding: 0px 2px 0px 2px;
              color: @gray;
            }
            #workspaces button.${focus} {
              font-weight: normal;
              color: @dark;
              background-color: @accent;
              padding: 0px 6px 0px 6px;
            }

            window#waybar {
              background-color: @dark;
            }
            #window { padding: 0px 10px 0px 10px; }

            /* calendar look */
            tooltip {
              background-color: @dark;
              border: 2px;
              border-style: solid;
              border-color: @accent;
              font-size: 15px;
            }

          	#network.disconnected { color: @gray;}
          	#network.disabled { color: @yellow; }

          	#idle_inhibitor.activated { color: @green; }
          	#idle_inhibitor.deactivated { color: @gray; }

          	#bluetooth { color: @green; }
          	#bluetooth.disabled { color: @gray; }

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
          	@keyframes blink { to { color: @white; } }
        '';
    };
}
