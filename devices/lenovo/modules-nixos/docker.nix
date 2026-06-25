# for configuration.nix
{
  username,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # xhost # x11 support?
  ];
  virtualisation.docker.enable = true;
  # virtualisation.docker.storageDriver = "btrfs";
  users.users.${username}.extraGroups = ["docker"];
}
