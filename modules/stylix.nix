{ pkgs, config, lib, ... }: {
  stylix = {
    enable = true;

    image = ../images/space8.jpg;

    # based theme 
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-terminal-dark.yaml";

    # blue light free theme!
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.unifont;
        name = "Unifont"; # my local font
      };
      sansSerif = {
        package = pkgs.unifont;
        name = "Unifont"; # my local font
      };
      serif = {
        package = pkgs.unifont;
        name = "Unifont"; # my local font
      };
      emoji = {
        package = pkgs.unifont;
        name = "Unifont"; # my local font
      };

      sizes = {
        # be careful when using certain values (for example 19)
        # check fonts settings in qt6ct program for valid values (I hate it)
        applications = 20;
        terminal = 22;
        # Window titles, status bars, and other general elements of the desktop.
        desktop = 16;
        popups = config.stylix.fonts.sizes.desktop;
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    polarity = "dark";
  };

  # QT STUFF WORKS DON'T TOUCH IT
  # qt.enable = lib.mkForce true;
  # qt.platformTheme = "gnome";
  # qt.style = "adwaita-dark";
  stylix.targets.qt.enable = true;
}
