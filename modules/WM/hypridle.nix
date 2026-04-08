{ ... }: {

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "swaylock"; # avoid starting multiple hyprlock instances.
        after_sleep_cmd =
          "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "brightnessctl -s set 50";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 660;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 675;
          on-timeout = "swaylock && hyprctl keyword input:kb_layout us,ru";
        }
      ];
    };
  };

}

# on-timeout = [
#                 "brightnessctl -s set 50"         # set monitor backlight to minimum, avoid 0 on OLED monitor.
#                 "brightnessctl -sd rgb:kbd_backlight set 0" # turn off keyboard backlight.
#             ];
#             on-resume = [
#                 "brightnessctl -r"
#                 "brightnessctl -rd rgb:kbd_backlight"
#             ];
