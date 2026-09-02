{
  config,
  lib,
  ...
}: {
  stylix.fonts.sizes = lib.mkForce {
    # be careful when using certain values (for example 19)
    # check fonts settings in qt6ct program for valid values (I hate it)
    applications = 25;
    terminal = 26;
    # Window titles, status bars, and other general elements of the desktop.
    desktop = 22;
    popups = config.stylix.fonts.sizes.desktop;
  };
}
