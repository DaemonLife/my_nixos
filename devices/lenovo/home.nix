{ pkgs, lib, config, inputs, ... }: {
  imports = [ ./modules/_import.nix ];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # unstable.digikam
    # unstable.darktable
    # unstable.hugin
    digikam
    kdePackages.kdenlive
    darktable
    hugin
    siril

    # games
    bottles
    lutris
  ];

  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = { speed = 0.8; };
  };

  # ==================
  #   kdeconnect 
  # ==================

  # services.kdeconnect = {
  #   enable = true;
  #   indicator = true;
  # };

}
