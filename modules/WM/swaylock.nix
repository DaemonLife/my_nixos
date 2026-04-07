{ config, lib, ... }: with config.lib.stylix.colors; {

  programs.swaylock = {
    enable = true;
    settings = {
      color = lib.mkForce "000000";

      inside-color = lib.mkForce "00000000";
      inside-clear-color = lib.mkForce "00000000";
      inside-caps-lock-color = lib.mkForce "00000000";
      inside-ver-color = lib.mkForce "00000000";
      inside-wrong-color = lib.mkForce "00000000";

      layout-bg-color = lib.mkForce "00000000";
      layout-border-color = lib.mkForce "00000000";
      layout-text-color = lib.mkForce "${base0E}";

      ring-color = lib.mkForce "${base00}";
      ring-clear-color = lib.mkForce "${base06}";
      ring-ver-color = lib.mkForce "${base0B}";
      ring-wrong-color = lib.mkForce "${base08}";
      ring-caps-lock-color = lib.mkForce "${base0F}";

      key-hl-color = lib.mkForce "${base0B}";
      bs-hl-color = lib.mkForce "${base08}";
      separator-color = lib.mkForce "00000000";
      text-color = lib.mkForce "${base02}";
      text-clear-color = lib.mkForce "${base06}";
      text-caps-lock-color = lib.mkForce "${base0F}";
      text-ver-color = lib.mkForce "${base0B}";
      text-wrong-color = lib.mkForce "${base08}";

      font-size = 42;

      indicator-idle-visible = false;
      indicator-radius = 110;
      indicator-thickness = 14;
      line-uses-ring = true;

      show-failed-attempts = true;

      ignore-empty-password = true;
      daemonize = false;
      show-keyboard-layout = false;
      hide-keyboard-layout = true;
      indicator-caps-lock = true;

      image = lib.mkForce "$HOME/nix/scripts/maze/maze.png";
    };

  };

}
