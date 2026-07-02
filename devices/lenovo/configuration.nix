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

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [mesa.opencl]; # OpenCL support using rusticl
    };
    # amdgpu.opencl.enable = true; # OpenCL support using ROCM (bug with darktable)
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest; # latest default kernel (bug with darktable on both channels)

  environment.systemPackages = with pkgs; [
    # amdgpu_top # Tool to display AMDGPU usage
    nvtopPackages.amd # nvtop - (h)top like task monitor for gpu
    clinfo # Print information about available OpenCL platforms and devices
    # displaycal
    # argyllcms # for displaycal
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

  # https://wiki.nixos.org/wiki/Power_Management
  # Disabling wakeup triggers for all PCIe devices
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  # '';
  services.udev.extraRules = ''
    ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x1483" ATTR{power/wakeup}="disabled"
  '';

  # --------------------------------
  # OTHER
  # --------------------------------

  system.stateVersion = "25.11";
  home-manager.users.${username} = {
    home.stateVersion = config.system.stateVersion;
  };
}
