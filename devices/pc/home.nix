{pkgs, ...}: {
  imports = [./modules/_import.nix];

  home.packages = with pkgs; [
    digikam
    darktable # flatpak is faster
    # kdePackages.kdenlive # flatpak
    hugin
    siril
    unstable.rapidraw

    # games
    # bottles # flatpak is better for sundbox
    # lutris # flatpak?
  ];
}
