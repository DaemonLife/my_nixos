{
  config,
  pkgs,
  lib,
  ...
}: {
  # --------------------------------
  # SYSTEM THEME
  # --------------------------------

  imports = [./modules/stylix.nix];

  # TTYI colors
  console = with config.lib.stylix.colors; {
    colors = lib.mkForce [
      "000000" # background
      "${base08}" # red
      "${base0B}" # green
      "${base0A}" # yellow
      "${base0D}" # blue
      "${base0E}" # magenta
      "${base0C}" # cyan
      "${base05}" # base05
      "${base03}" # base03
      "${base08}" # red
      "${base0B}" # green
      "${base0A}" # yellow
      "${base0D}" # blue
      "${base0E}" # magenta
      "${base0C}" # cyan
      "${base06}" # base06
    ];
  };

  # --------------------------------
  # ENVIRONMENTS
  # --------------------------------

  environment = {
    variables = let
      EDITOR = "vi";
    in {
      EDITOR = "${EDITOR}";
      SYSTEMD_EDITOR = "${EDITOR}";
      VISUAL = "${EDITOR}";
      BROWSER = "qutebrowser";
    };
    sessionVariables.NIXOS_OZONE_WL = "1"; # Run Electron apps without XWayland
  };

  # --------------------------------
  # HARDWARE SETTINGS
  # --------------------------------

  hardware.graphics.enable = true; # gparhic drivers
  powerManagement.enable = true; # NixOS power management tool

  # Network
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # Print and scan
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint # Drivers for many different printers from many different vendors.
    # gutenprintBin # Additional, binary-only drivers for some printers.
    # hplip # Drivers for HP printers.
    # postscript-lexmark # Postscript drivers for Lexmark
    # splix # Drivers for printers supporting SPL (Samsung Printer Language).
    # brlaser # Drivers for some Brother printers
    # brgenml1lpr # Generic drivers for more Brother printers
    # fxlinuxprint # Fuji Xerox Linux Printer Driver
    # samsung-unified-linux-driver # Proprietary Samsung Drivers
    # cnijfilter2 # Proprietary drivers for some Canon Pixma devices
    # foomatic-db-ppds-withNonfreeDb
  ];
  hardware.sane.enable = true; # enables support for scanners
  hardware.sane.extraBackends = [pkgs.sane-airscan];
  services.udev.packages = [pkgs.sane-airscan]; # device manager for the Linux kernel

  # Sound
  security.rtkit.enable = true; # rtkit is optional but recommended for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # important for waybar
    jack.enable = true; # If you want to use JACK applications
  };

  # Time
  time.timeZone = "Europe/Moscow";
  time.hardwareClockInLocalTime = true;

  # Lang
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # --------------------------------
  # USER SETTINGS
  # --------------------------------

  users.users.user = {
    isNormalUser = true;
    description = "user";
    shell = pkgs.fish;
    useDefaultShell = true;

    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "scanner"
      "lp"
    ];

    packages = with pkgs; [flatpak];
  };

  # --------------------------------
  # NIX SETTING
  # --------------------------------

  nixpkgs.config = {
    allowUnfree = true;
  };
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise.automatic = true;
    settings.auto-optimise-store = true;
  };

  # --------------------------------
  # SYSTEM PACKAGES
  # --------------------------------

  environment.systemPackages = with pkgs; [
    gparted
    os-prober
    ntfs3g # ntfs support
    exfatprogs # exfat gparted support
    clinfo # opencl info
    mesa # video driver
    jdk # java
    impala # wifi tui
    iwd # wifi cli, don't delete!
    bluez
    kitty
    udiskie # auto disks mount
    nufraw-thumbnailer # RAW preview for thunar
    colord-gtk4 # color profiles support
    xdg-desktop-portal-termfilechooser # make yazi default file chooser
    # ueberzugpp # ???

    # GNOME programs
    adwaita-icon-theme

    protonup-qt
    # vulkan-validation-layers
  ];

  # --------------------------------
  # SYSTEM PROGRAMS
  # --------------------------------

  qt.enable = true;

  # # for flatpak
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  # Android emulator. Read https://nixos.wiki/wiki/WayDroid
  # virtualisation.waydroid.enable = true;

  programs = {
    # sway = {
    #   enable = true;
    #   wrapperFeatures.gtk = true; # gtk fix
    #   extraPackages = with pkgs; [
    #     swaylock
    #     swayidle
    #     grim # screenshot functionality
    #     slurp # screenshot functionality
    #     wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    #     mako # notification system developed by swaywm maintainer
    #   ];
    # };

    # --- hyprland ---
    # hyprland = {
    #   enable = true;
    #   withUWSM = true;
    # };
    # --- hyprland ---

    niri.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "/home/$USER/nix";
    };

    # --- thunar ---
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    xfconf.enable = true;
    # --- thunar ---

    proxychains = {
      # just default settings ...
      enable = true;
      proxyDNS = true;
      chain.type = "strict";
      localnet = "127.0.0.0/255.0.0.0";
      tcpReadTimeOut = 15000;
      tcpConnectTimeOut = 8000;
      remoteDNSSubnet = 224;
      proxies = {
        myproxy = {
          type = "socks5";
          host = "127.0.0.1";
          port = 10808; # ... and only my port
          enable = true;
        };
      };
    };

    # ------ Steam ------
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      # Open ports in the firewall for:
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    gamemode.enable = true; # micro compositor
    # ------ Steam ------

    dconf.enable = true;
    htop.enable = true;
    git.enable = true;
    fish.enable = true;
    amnezia-vpn.enable = true;
  };

  # --------------------------------
  # SYSTEM SERVICES
  # --------------------------------

  services = {
    xray = {
      enable = true;
      settingsFile = "/etc/xray/config.json";
    };

    # colord.enable = true; # color profiles
    openssh.enable = true;
    flatpak.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thunar thumbnail support for images
    gnome.gnome-keyring.enable = true; # for sway
    power-profiles-daemon.enable = false; # disable for tlp
    thermald.enable = true; # Thermald prevents overheating
    # xserver.displayManager.gdm.enable = true;
    # xserver.displayManager.startx.enable = true;
    # xserver.desktopManager.gnome.enable = true;
  }; # close services

  systemd = {
    # authentication for programs
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      # AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
      HibernateDelaySec=3600
    '';
  };

  # --------------------------------
  # SECURITY
  # --------------------------------

  security = {
    polkit.enable = true; # authentication support for sway
    pam.services.swaylock = {}; # screen lock
  };

  # --------------------------------
  # BOOT OPTIONS
  # --------------------------------

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      default = "saved";
      splashImage = lib.mkForce null;
      theme = lib.mkForce null;
      fontSize = lib.mkForce 30;
      extraConfig = lib.mkForce ''
        GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1"
      '';
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

  # --------------------------------
  # OTHER STUFF
  # --------------------------------

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
