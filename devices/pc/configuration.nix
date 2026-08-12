{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules-nixos/_import.nix
  ];

  networking.hostName = lib.mkForce "pc";

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.opencl.enable = true; # ROCM runtime
    amdgpu.initrd.enable = true; # init hd monitor, sets boot.initrd.kernelModules = ["amdgpu"];
    bluetooth.enable = lib.mkForce false;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    qemu # vm: quickget windows 10; quickemu --vm windows-10.conf
    # amdgpu_top # Tool to display AMDGPU usage
    nvtopPackages.amd # nvtop - (h)top like task monitor for gpu
    clinfo # Print information about available OpenCL platforms and devices
    displaycal
    argyllcms # for displaycal
    # android-tools # adb, fastboot support
  ];

  # --------------------------------
  # HIBERNATION
  # --------------------------------

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  system.stateVersion = "26.05";
  home-manager.users.${username} = {
    home.stateVersion = config.system.stateVersion;
  };
}
