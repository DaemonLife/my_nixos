{
  pkgs,
  config,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules-nixos/_import.nix
  ];

  # --------------------------------
  # GPU, pkgs, kernel
  # --------------------------------

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
      size = 32 * 1024; # 32GB
    }
  ];

  # --------------------------------
  # OTHER
  # --------------------------------

  system.stateVersion = "26.05";
  home-manager.users.${username} = {
    home.stateVersion = config.system.stateVersion;
  };
}
