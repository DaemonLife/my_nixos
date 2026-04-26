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
  # iGPU, pkgs, kernel
  # --------------------------------

  # hardware = {
  #   graphics = {
  #     enable = true;
  #     enable32Bit = true;
  # extraPackages = with pkgs; [ mesa.opencl ]; # OpenCL support using rusticl
  # };
  # amdgpu.opencl.enable = true; # OpenCL support using ROCM (bug with darktable)
  # };

  # boot.kernelPackages = pkgs.linuxPackages_latest; # latest default kernel (bug with darktable on both channels)

  environment.systemPackages = with pkgs; [
    amdgpu_top # Tool to display AMDGPU usage
    nvtopPackages.amd # (h)top like task monitor for gpu
    clinfo # Print information about available OpenCL platforms and devices
    displaycal
    argyllcms # for displaycal
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
  boot.initrd.systemd.enable = true; # idk but it works

  # (NOT TESTED) Specifies what to do when the laptop lid is closed
  services.logind.settings = {
    Login.HandleLidSwitch = "suspend-then-hibernate";
  };

  # --------------------------------
  # OTHER
  # --------------------------------

  system.stateVersion = "25.11";
  home-manager.users.${username} = {
    home.stateVersion = config.system.stateVersion;
  };
}
