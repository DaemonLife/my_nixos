{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    extraArgs = ["-w"];
    systemdTargets = ["sway-session.target"];

    events = {
      "before-sleep" = "swaymsg input 'type:keyboard' xkb_switch_layout 0; ${pkgs.swaylock}/bin/swaylock -fF";
      "after-resume" = ''swaymsg "output * power on"'';
      # Command to run when the logind session is
      # "lock" = "";
      # "unlock" = "";
    };

    timeouts = [
      {
        timeout = 540;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 600;
        command = "swaymsg input 'type:keyboard' xkb_switch_layout 0; ${pkgs.swaylock}/bin/swaylock -fF";
        resumeCommand = "";
      }
      {
        timeout = 720;
        command = ''swaymsg "output * power off"'';
        resumeCommand = ''swaymsg "output * power on"'';
      }
      {
        timeout = 3600; # 1h
        command = "${pkgs.systemd}/bin/systemctl hibernate";
      }
    ];
  };
}
