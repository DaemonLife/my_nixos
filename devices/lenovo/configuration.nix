{ pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ./modules-nixos/_import.nix
  ];

  # --------------------------------
  # iGPU, pkgs, kernel
  # --------------------------------

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ mesa.opencl ]; # OpenCL support using rusticl
    };
    # amdgpu.opencl.enable = true; # OpenCL support using ROCM (bugs!)
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest; # latest default kernel
  # boot.kernelPackages = pkgs.linuxPackages_lqx; # need compiling
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # bug with darktable

  environment.systemPackages = with pkgs; [
    amdgpu_top # Tool to display AMDGPU usage
    nvtopPackages.amd # (h)top like task monitor for gpu
    clinfo # Print information about available OpenCL platforms and devices
    displaycal
    argyllcms # for displaycal
  ];

  system.stateVersion = "24.11";
}
