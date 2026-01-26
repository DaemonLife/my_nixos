{ config
, pkgs
, lib
, username
, ...
}: {
  imports = [ ./modules/_import.nix ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    sessionPath = [ "/home/${username}/.local/bin" ];
    sessionVariables = {
      BROWSER = "qutebrowser";
      TERMINAL = "foot";
    };
    stateVersion = "24.05";

    # --------------------------------
    # HOME PKGS
    # --------------------------------

    packages = with pkgs; [
      pipx
      exiftool
      imagemagick
      zip
      unzip
      fzy
      # dua # disk usage TUI tool. Run: dua i. REMOVED: ncdu is better

      # Network
      overskride # bluetooth gui
      bluetui # bluetooth tui
      bitwarden-cli
      qbittorrent # torrent client
      tor-browser
      deltachat-desktop
      vivaldi

      # Media
      unstable.gimp
      helvum # A GTK patchbay for pipewire
      imagemagick
      ffmpegthumbnailer
      pavucontrol # audio gui control
      alsa-utils # audio volume control (?)
      pulsemixer # cli pulse adudio control
      nomacs-qt6 # image viewer
      kdePackages.gwenview
      kodi-wayland
      obs-studio
      upscayl
      freefilesync
      foliate

      # Theming
      vimix-icon-theme # cursor icon
      gowall # Tool to convert a Wallpaper's color scheme
      grc
      fontpreview # --preview-text "Привет, как дела, это просто тест шрифта!!! 1234567890?*# Just a test for my font."

      # Utils
      dconf-editor
      cool-retro-term
      veracrypt
      cmatrix # matrix in terminal
      wev # key events in wayland
      nwg-displays # gui for display setup
      gucharmap # character map
      # https://github.com/ChrisBuilds/terminaltexteffects

      # Docs
      onlyoffice-desktopeditors
      stellarium # astro map
      astroterm # astro map ASCII
      epy # cli book reader
      tldr # community documentation
      russ # rss tui reader
      gnome-feeds # gui rss reader
      # libreoffice
      hunspell # spellcheck
      hunspellDicts.ru_RU # spellcheck
      hunspellDicts.en_US # spellcheck

      # Gaming
      # unstable.portablemc # minecraft cli launcher
      curseofwar # stategy cli game
      vitetris # tetris cli game
      unstable.mindustry-wayland
      # dwarf-fortress-packages.dwarf-fortress-full
    ];
  };

  # --------------------------------
  # HOME PROGRAMS
  # --------------------------------

  programs = {
    fastfetch = {
      enable = true;
    };
    yt-dlp = {
      enable = true;
    };
    imv = {
      enable = true;
    };

    bash = {
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    btop = {
      enable = true;
      settings = {
        color_theme = lib.mkForce "TTY";
        theme_background = lib.mkForce false;
        rounded_corners = lib.mkForce false;
        vim_keys = lib.mkForce true;
      };
    };
  };

  dconf = {
    settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ""; # disable top right buttons
      };
    };
  };
}
