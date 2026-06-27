{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.configurationLimit = lib.mkForce 3; # bc no space in /boot

  # --------------------------------
  # HIBERNATION
  # --------------------------------

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  # https://wiki.nixos.org/wiki/Power_Management
  # Disabling wakeup triggers for all PCIe devices
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

  # --------------------------------
  # OTHER
  # --------------------------------

  system.stateVersion = "24.11";
  home-manager.users.user = {
    home.stateVersion = config.system.stateVersion;
  };
}
