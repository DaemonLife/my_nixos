# Configuration for Lenovo
{pkgs, ...}: {
  # Imports
  imports = [./hardware-configuration.nix];

  # Enable AMD video driver
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [rocmPackages.clr.icd amdvlk];
  };
  hardware.amdgpu.opencl.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  # enable HIP
  systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];

  # --------------------------------
  # HIBERNATION
  # --------------------------------

  # swap file
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
  # hibernation (swap file is necessary)
  boot.initrd.systemd.enable = true;
  # Specifies what to do when the laptop lid is closed
  # services.logind.lidSwitch = "suspend-then-hibernate";

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

        # improve disk IO
        # DISK_IOSCHED = "";
      };
    }; # tlp
  }; # services

  system.stateVersion = "24.11";
}
