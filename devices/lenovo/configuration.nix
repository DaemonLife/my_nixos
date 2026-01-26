# Configuration for Lenovo
{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./modules-nixos/_import.nix ];

  # --------------------------------
  # iGPU
  # --------------------------------

  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [ unstable.mesa.opencl ]; # OpenCL support using rusticl
      extraPackages = with pkgs; [ mesa.opencl ]; # OpenCL support using rusticl
    };
    # amdgpu.opencl.enable = true; # OpenCL support using ROCM (bugs!)
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top # Tool to display AMDGPU usage
    nvtopPackages.amd # (h)top like task monitor for gpu
    clinfo # Print information about available OpenCL platforms and devices
    displaycal
    argyllcms # for displaycal
  ];

  # GPU configuration and charts tool
  # services.lact.enable = true;

  # --------------------------------
  # HIBERNATION
  # --------------------------------

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16GB
  }];
  boot.initrd.systemd.enable = true; # enable systemd
  boot.kernelPackages = pkgs.linuxPackages_lqx; # gaming kernel

  # --------------------------------
  # OTHER SERVICES
  # --------------------------------

  services = {
    # Battery life / TLP
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 100;

        CPU_BOOST_ON_AC = "1";
        CPU_BOOST_ON_BAT = "0";

        # Controls runtime power management for PCIe devices (Fan).
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        CONSERVATION_MODE = 1;
        TLP_DEFAULT_MODE = "conservation";
      };
    };
  };

  # -------------
  # FIREWALL
  # -------------

  networking.firewall = rec {
    # kdeconnect
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  system.stateVersion = "24.11";
}
