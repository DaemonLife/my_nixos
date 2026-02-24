{ pkgs, config, ... }: {

  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;

    settings = {
      preview = true;
      hidden = false;
      drawbox = true;
      icons = false;
      ignorecase = true;
    };

    keybindings = {
      ad = "mkdir";
      "." = "set hidden!";
      "<enter>" = "open";
      # ee = "editor-open";
      gh = "cd";
      gn = "cd ~/nix";
      gd = "cd ~/Downloads";
      gw = "cd /mnt/windows/Users/user";
      go = "dragon-out";
      bo = "cd ~/.local/share/Trash/files";
      be = "trash-empty";
      d = "trash";
      x = "cut";
      p = "paste";
      y = "copy";
    };

    commands = {
      # editor-open = "$hx $f";

      dragon-out = ''%files=(''${fx}) && ${pkgs.dragon-drop}/bin/xdragon -a -x "''${files[@]}"'';

      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
      '';
      trash-empty = ''%trash-empty'';
      trash = ''
        %{{
          # put items into array that we can count them
          files=()
          while read -r line; do files+=("$line"); done <<< "$fx"
          
          # count how many items there are
          len=''${#files[@]}
          
          # confirm trashing
          if [[ $len == 1 ]]; then
            echo -n "trash '$fx' ?"
          else
            echo -n "trash $len items?"
          fi
          echo -n " [y/N] "
          
          # read answer
          read -n 1 ans
          # make it lowercase
          ans="''${ans,,}" 
          
          echo
          
          # nuke
          if [[ $ans == y ]]; then
            ${pkgs.trash-cli}/bin/trash-put $fx
            if [[ $len == 1 ]]; then
              echo "trashed '$files'"
            else
              echo "trashed $len items"
            fi
          else
            # needed to clear the bottom row
            echo
          fi
        }}
      '';
    };

    extraConfig =
      let
        previewer =
          pkgs.writeShellScriptBin "pv.sh" ''
            file=$1
            w=$2
            h=$3
            x=$4
            y=$5

            if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
                ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
                exit 1
            fi

            ${pkgs.pistol}/bin/pistol "$file"
          '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in
      ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';

  };
}
