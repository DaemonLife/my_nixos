{ config, pkgs, ... }: {
  home.packages = with pkgs;[ unison ];

  home.file.".unison/default.prf".text = ''
    # Unison preferences file

    # when neovim will be open save your result only in first buffer!!!

    ### withoin backup ###
    merge = Name *.{txt,md} -> kitty sh -c 'nvim -d "$1" "$2" && cp "$1" "$3" && exit' sh CURRENT1 CURRENT2 NEW

    ###  with backup  ###
    # merge = Name *.txt -> kitty sh -c 'nvim -d "$1" "$2" "$3" && cp "$1" "$4" && exit' sh CURRENT1 CURRENTARCHOPT CURRENT2 NEW
    # backup = Name *.txt
    # backupcurr = Name *.txt
    # backupcurrent = Name *.txt
    # backupnot = Name *.tmp
    # maxbackups = 2
  '';
}
