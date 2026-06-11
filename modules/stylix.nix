{
  pkgs,
  config,
  lib,
  ...
}: let
  image_bg = ../images/current_bg/bg.png;
in {
  stylix = {
    enable = true;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-terminal-dark.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    image = image_bg;

    fonts = let
      package = pkgs.nerd-fonts.iosevka-term;
      name = "IosevkaTerm Nerd Font Mono";
    in {
      monospace = {
        package = package;
        name = name;
      };
      sansSerif = {
        package = package;
        name = name;
      };
      serif = {
        package = package;
        name = name;
      };
      emoji = {
        package = package;
        name = name;
      };

      sizes = {
        applications = 18;
        terminal = 18;
        # Window titles, status bars, and other general elements of the desktop.
        desktop = 16;
        popups = config.stylix.fonts.sizes.desktop;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = config.stylix.fonts.sizes.terminal + 2;
    };

    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    polarity = "dark";
  };

  stylix.targets.qt.enable = true;
}
