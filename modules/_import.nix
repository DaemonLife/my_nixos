{...}: {
  imports = [
    ./git.nix
    ./jrnl.nix
    # ./rtorrent.nix
    ./gowall.nix
    ./gtk.nix
    ./fzf.nix
    ./stylix.nix
    # ./joplin.nix
    ./GIMP.nix
    # ./nomacs.nix
    # ./chess/cli-chess.nix
    ./xdg.nix
    ./unison.nix

    ./shell/_import.nix
    ./terminal/_import.nix
    ./editor/_import.nix
    ./file_manager/_import.nix
    ./WM/_import.nix
    ./player/_import.nix
    ./telegram/_import.nix
    ./browser/_import.nix
    ./type/_import.nix
  ];
}
