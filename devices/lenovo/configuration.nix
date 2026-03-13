{ pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ./modules-nixos/_import.nix
  ];

  # --------------------------------
  # iGPU, pkgs, kernel
  # --------------------------------

  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ unstable.mesa.opencl ]; # OpenCL support using rusticl
      # extraPackages = with pkgs; [ mesa.opencl ]; # OpenCL support using rusticl
    };
    # amdgpu.opencl.enable = true; # OpenCL support using ROCM (bugs!)
  };

  # boot.kernelPackages = pkgs.linuxPackages_lqx; # switch to gaming kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # switch to gaming kernel

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

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16GB
  }];

  system.stateVersion = "24.11";
}
