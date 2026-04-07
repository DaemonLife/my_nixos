{ pkgs, config, lib, ... }: {
  stylix = {
    enable = true;

    image = ../images/space8.jpg;

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-terminal-dark.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    fonts =
      let
        package = pkgs.cozette;
        name = "CozetteVector";
        # name = "UnifontExMono"; # my local font
      in
      {
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
          # be careful when using certain values (for example 19)
          # check fonts settings in qt6ct program for valid values (I hate it)
          applications = 22;
          terminal = 24;
          # Window titles, status bars, and other general elements of the desktop.
          desktop = 20;
          popups = config.stylix.fonts.sizes.desktop;
        };
      };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = config.stylix.fonts.sizes.terminal + 4;
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
