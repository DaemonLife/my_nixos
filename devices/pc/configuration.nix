# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
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

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [mesa.opencl]; # OpenCL support using rusticl
    };
    amdgpu.opencl.enable = true; # OpenCL support using ROCM (bug with darktable)

    bluetooth.enable = lib.mkForce true;
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

  system.stateVersion = "26.05";
  home-manager.users.${username} = {
    home.stateVersion = config.system.stateVersion;
  };
}
