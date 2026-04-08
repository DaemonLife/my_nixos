{ ... }: {
  programs.fish = {

    shellAliases = {
      mwin = "$HOME/nix/scripts/mount_windows.sh /dev/nvme0n1p3 user";
    };
    shellAbbrs = {
      cdwin = "mwin && cd /mnt/windows/Users/user/";
    };
  };

}

