{...}: {
  # i3_configuration.nix for configuration.nix file
  imports = [
    # ./i3_home.nix
    # ./sway.nix
    # ./niri.nix # no color profile support
    ./hyprland.nix
  ];
}
