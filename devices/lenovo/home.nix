{pkgs, ...}: {
  imports = [./modules/_import.nix];

  home.packages = with pkgs; [
    unstable.digikam
    unstable.darktable
    unstable.kdePackages.kdenlive

    # digikam
    # darktable
    hugin
    siril

    # games
    bottles
    lutris
  ];

  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {speed = 0.8;};
  };

  # ==================
  #   kdeconnect
  # ==================

  # services.kdeconnect = {
  #   enable = true;
  #   indicator = true;
  # };
}
