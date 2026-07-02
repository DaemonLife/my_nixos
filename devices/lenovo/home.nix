{pkgs, ...}: {
  imports = [./modules/_import.nix];

  home.packages = with pkgs; [
    digikam
    # darktable
    kdePackages.kdenlive
    hugin
    siril

    # games
    # bottles
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
