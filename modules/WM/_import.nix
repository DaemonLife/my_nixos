{...}: {
  # i3_configuration.nix for configuration.nix file
  imports = [
    # ./i3/i3_home.nix
    # ./sway.nix # still bad color profile support and only with vulkan
    # ./niri.nix # no color profile support
    ./hyprland.nix # good color profile support
    # mangooooo # no color profile support only hdr
  ];
}
