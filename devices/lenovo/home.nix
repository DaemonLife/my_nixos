{pkgs, ...}: {
  imports = [./modules/_import.nix];

  home.packages = with pkgs; [
    digikam
    # unstable.darktable # flatpak is faster
    # kdePackages.kdenlive # flatpak
    hugin
    siril

    # games
    # bottles # flatpak is better for sundbox
    # lutris # flatpak?
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
