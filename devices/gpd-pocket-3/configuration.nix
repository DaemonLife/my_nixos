{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # --------------------------------
  # HIBERNATION
  # --------------------------------

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16GB
  }];
  boot.initrd.systemd.enable = true;

  # Specifies what to do when the laptop lid is closed
  services.logind.settings = {
    Login.HandleLidSwitch = "suspend-then-hibernate";
  };

  # --------------------------------
  # OTHER
  # --------------------------------

  system.stateVersion = "24.11";
}
