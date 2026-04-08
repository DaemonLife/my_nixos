{pkgs, ...}: {
  home.packages = with pkgs; [swayidle];
  services.swayidle = {
    enable = true;
    #   systemdTarget = "hyprland-session.target";
    #   events = [
    #     {
    #       event = "before-sleep";
    #       command = "swaylock";
    #     }
    #     {
    #       # this gets triggered after sleep
    #       event = "after-resume";
    #       command = "hyprctl dispatch dpms on";
    #     }
    #     {
    #       # this system usually doesn't suspend
    #       # also turn on monitors on unlock
    #       event = "unlock";
    #       command = "hyprctl dispatch dpms on";
    #     }
    #   ];

    #   timeouts = [
    #     {
    #       timeout = 15;
    #       command = "swaylock";
    #     }
    #     {
    #       timeout = 20;
    #       command = "hyprctl dispatch dpms off";
    #     }
    #   ];
  };
}
