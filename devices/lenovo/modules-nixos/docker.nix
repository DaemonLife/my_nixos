# for configuration.nix
{ username, ... }: {
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  users.users.${username}.extraGroups = [ "docker" ];
}

