{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    # ./hyprland.nix
    ./waybar.nix
    ./mako.nix
    ./sway.nix
  ];
}
