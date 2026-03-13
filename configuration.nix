{ config, pkgs, lib, username, ... }: {

  imports = [
    ./modules/stylix.nix
    ./modules/WM/i3_configuration.nix
    # ./modules/editor/nvf.nix
  ];

  # --------------------------------
  # NET AND HARDWARE SETTINGS
  # --------------------------------

  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
    nameservers = [ "1.1.1.1" "1.0.0.1" ]; # DNS provider
    hosts = { "192.168.1.150" = [ "myphone" ]; }; # local DNS
    nftables.enable = true; # disable old iptables
    firewall = {
      enable = true;
      allowedTCPPorts = [
        6567 # mindusty server
      ];
      allowedUDPPorts = [
        6567 # mindusty server
      ];
    };
  };

  hardware.bluetooth = { enable = true; powerOnBoot = false; };
  time = { timeZone = "Europe/Moscow"; hardwareClockInLocalTime = true; };

  # Printers
  services.printing = {
    enable = true;
    drivers = with pkgs; [
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
  };

  # Scanners
  hardware.sane = { enable = true; extraBackends = [ pkgs.sane-airscan ]; };
  services.udev.packages = [ pkgs.sane-airscan ]; # device manager for the Linux kernel

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # important for waybar
    jack.enable = true; # If you want to use JACK applications
  };
  security.rtkit.enable = true; # rtkit is optional but recommended for pipewire

  # Region
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

  users.users.${username} = {
    isNormalUser = true;
    description = "my user";
    # shell = pkgs.fish;
    shell = pkgs.zsh;
    useDefaultShell = true;
    packages = with pkgs; [ flatpak ];
    extraGroups = [ "networkmanager" "wheel" "video" "input" "scanner" "lp" ];
  };

  # --------------------------------
  # ENVIRONMENTS
  # --------------------------------

  environment = {
    variables = let EDITOR = "vi"; in {
      EDITOR = "${EDITOR}";
      SYSTEMD_EDITOR = "${EDITOR}";
      VISUAL = "${EDITOR}";
      BROWSER = "qutebrowser";
    };
    shells = with pkgs; [ zsh ];
    sessionVariables.NIXOS_OZONE_WL = "1"; # Run Electron apps without XWayland
  };

  # --------------------------------
  # NIX SETTING
  # --------------------------------

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    optimise.automatic = true;
  };

  # --------------------------------
  # SYSTEM PACKAGES
  # --------------------------------

  environment.systemPackages = with pkgs; [
    gparted
    exfatprogs # exfat gparted support
    ntfs3g # ntfs support
    os-prober # to find systems in grub
    sshfs # ssh mount as directory
    jdk # java
    iwd # wifi cli, don't delete!
    bluez # official Linux Bluetooth protocol stack
    udiskie # auto disks mount
    nautilus
    net-tools # for netstat
    wget
    nmap # scan network map: nmap -sn 192.168.1.0/24
    ncdu # folder size tree
    mangohud # Steam performance GUI
    zip
    unzip
  ];

  # --------------------------------
  # SYSTEM PROGRAMS
  # --------------------------------

  xdg.portal = lib.mkDefault {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # wlr.enable = true;
    # config.common.default = "wlr"; # 'wlr' for wayland wm, 'gnome' for gnome
  };

  # Android emulator. Read https://nixos.wiki/wiki/WayDroid
  # virtualisation.waydroid.enable = true;

  programs = {
    # hyprland = { enable = true; withUWSM = true; };
    # niri.enable = true;

    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 7d --keep 5";
      };
      flake = "/home/${username}/nix";
    };

    # thunar = {
    #   enable = true;
    #   plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ];
    # };
    # xfconf.enable = true;

    # proxychains = {
    #   # just default settings ...
    #   enable = true;
    #   proxyDNS = true;
    #   chain.type = "strict";
    #   localnet = "127.0.0.0/255.0.0.0";
    #   tcpReadTimeOut = 15000;
    #   tcpConnectTimeOut = 8000;
    #   remoteDNSSubnet = 224;
    #   proxies = {
    #     myproxy = {
    #       type = "socks5";
    #       host = "127.0.0.1";
    #       port = 10808; # ... and only my port
    #       enable = true;
    #     };
    #   };
    # };

    # ------ Steam ------
    steam = {
      enable = true;
      package = pkgs.steam.override { extraEnv = { MANGOHUD = "1"; GAMEMODERUN = "1"; }; };
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    gamescope = { enable = true; capSysNice = true; };
    gamemode.enable = true; # Set run game parameters in Steam: gamemoderun %command%

    nix-ld.enable = true; # run bin files
    dconf.enable = true;
    htop.enable = true;
    git.enable = true;
    amnezia-vpn.enable = true;
    zsh.enable = true;
    # ssh.startAgent = true; # agent for ssh keys
  };

  # --------------------------------
  # SYSTEM SERVICES
  # --------------------------------

  services = {

    # battery 
    tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance"; # super performance
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # super save power

        PLATFORM_PROFILE_ON_BAT = "low-power"; # super save power

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 80;

        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 1;

        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      };
    };

    # auto username in tty
    getty = { loginOptions = "-- \\u"; autologinUser = "${username}"; autologinOnce = true; };

    # xray = { enable = true; settingsFile = "/etc/xray/config.json"; };
    openssh.enable = true;
    flatpak.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
    colord.enable = true; # color manager
  };

  systemd = {
    # authentication for programs
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
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
    # pam.services.swaylock = { }; # screen lock
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
      fontSize = lib.mkForce 60;
      extraConfig = lib.mkForce ''GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1"'';
    };
    efi.canTouchEfiVariables = true;
  };

  # --------------------------------
  # SYSTEM THEME
  # --------------------------------

  # TTYI colors
  console.colors = with config.lib.stylix.colors; lib.mkForce [
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
  stylix.targets.grub.enable = false;

}
