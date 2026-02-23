{ config, pkgs, ... }: {
  home.packages = with pkgs;[ unison ];

  home.file.".unison/default.prf".text = ''
    # Unison preferences file

    # when neovim will be open save your result only in first buffer!!!
    merge = Name *.txt -> kitty --hold sh -c 'nvim -d "$1" "$2" "$3"; cp "$1" "$4"' sh CURRENT1 CURRENTARCHOPT CURRENT2 NEW

    # Conflict resolution
    backup = Name *.txt
    backupcurr = Name *.txt
    backupcurrent = Name *.txt
    backupnot = Name *.tmp
    maxbackups = 2
  '';
}
