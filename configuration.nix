{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [
    ./modules/stylix.nix
  ];

  # --------------------------------
  # NET AND HARDWARE SETTINGS
  # --------------------------------

  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
    nameservers = ["1.1.1.1" "1.0.0.1"]; # DNS provider
    hosts = {"192.168.1.150" = ["myphone"];}; # local DNS
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
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  time = {
    timeZone = "Europe/Moscow";
    hardwareClockInLocalTime = true;
  };

  # Printers
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
    ];
  };

  # Scanners
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
  };
  services.udev.packages = [pkgs.sane-airscan]; # device manager for the Linux kernel

  # Sound
  security.rtkit.enable = true; # rtkit is optional but recommended for pipewire
  services.pipewire = {
    enable = true;
    # alsa.enable = true;
    # alsa.support32Bit = true; # waiting a bug fix https://nixpk.gs/pr-tracker.html?pr=534770
    # pulse.enable = true; # important for waybar
    # jack.enable = true; # If you want to use JACK applications
  };

  # battery
  powerManagement.enable = true;

  # video
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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
    shell = pkgs.zsh;
    useDefaultShell = true;
    packages = with pkgs; [flatpak];
    extraGroups = ["networkmanager" "wheel" "video" "input" "scanner" "lp"];
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
      BROWSER = "librewolf";
    };
    shells = with pkgs; [zsh];
    sessionVariables.NIXOS_OZONE_WL = "1"; # Run Electron apps without XWayland
  };

  # --------------------------------
  # SYSTEM PACKAGES
  # --------------------------------

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      trusted-users = ["user"];
      max-jobs = 8;
    };
    optimise.automatic = true;
  };

  # waitign for a bug fix https://nixpk.gs/pr-tracker.html?pr=534770
  nixpkgs.overlays = [
    (final: prev: {
      openblas =
        if prev.stdenv.hostPlatform.system == "i686-linux"
        then prev.openblas.overrideAttrs (_: {doCheck = false;})
        else prev.openblas;
    })
  ];

  environment.systemPackages = with pkgs; [
    gparted
    exfatprogs # exfat gparted support
    ntfs3g # ntfs support
    sshfs # ssh mount as directory
    jdk # java
    iwd # wifi cli, don't delete!
    bluez # official Linux Bluetooth protocol stack
    udiskie # auto disks mount
    nautilus
    net-tools # for netstat
    sysstat # for iostat
    iotop
    wget
    nmap # scan network map: nmap -sn 192.168.1.0/24
    ncdu # nice files size tree
    mangohud # Steam performance GUI
    zip
    unzip
    nix-tree # nix pkgs tree
  ];

  # --------------------------------
  # SYSTEM PROGRAMS
  # --------------------------------

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    wlr.enable = true;
    config.common.default = "wlr"; # 'wlr' for wayland wm, 'gnome' for gnome
  };

  programs = {
    # hyprland.enable = true;
    # niri.enable = true;
    sway.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    # vpn
    proxychains = {
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
          port = 20170;
          enable = true;
        };
      };
    };

    # ------ Steam ------
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = "1";
          GAMEMODERUN = "1";
        };
      };
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
      remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    gamemode.enable = true; # Set run game parameters in Steam: gamemoderun %command%

    nix-ld.enable = true; # run bin files
    dconf.enable = true;
    htop.enable = true;
    git.enable = true;
    zsh.enable = true;
  };

  # --------------------------------
  # SYSTEM SERVICES
  # --------------------------------

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "hibernate"; # default
      HandleLidSwitchExternalPower = "lock"; # powered
      HandleLidSwitchDocked = "ignore"; # with another screen
    };

    # battery
    auto-cpufreq.enable = true;
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };

    # auto username in tty
    getty = {
      loginOptions = "-- \\u";
      autologinUser = "${username}";
      autologinOnce = true;
    };

    v2raya.enable = true; # vpn
    openssh.enable = true;
    flatpak.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
    AllowHibernation = "yes";
  };

  # --------------------------------
  # SECURITY
  # --------------------------------

  # authentication for programs (frontend)
  # systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #   description = "polkit-gnome-authentication-agent-1";
  #   wantedBy = ["graphical-session.target"];
  #   wants = ["graphical-session.target"];
  #   after = ["graphical-session.target"];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };

  security.polkit.enable = true; # authentication support (backed)
  security.pam.services = {
    # open gnome keyring by swaylock
    swaylock.enableGnomeKeyring = true;
  };
  services.gnome.gnome-keyring.enable = true; # secret portal for matrix

  # fix performance issues for sway maybe
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  # --------------------------------
  # BOOT OPTIONS
  # --------------------------------

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 6;
    efi.canTouchEfiVariables = true;
  };

  # --------------------------------
  # SYSTEM THEME
  # --------------------------------

  # TTYI colors
  console.colors = with config.lib.stylix.colors;
    lib.mkForce [
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
}
