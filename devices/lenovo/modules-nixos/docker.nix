# for configuration.nix
{ username, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      xhost
    ];
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  users.users.${username}.extraGroups = [ "docker" ];
}

