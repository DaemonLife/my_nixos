{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [./modules/_import.nix];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    sessionPath = ["/home/${username}/.local/bin"];
    sessionVariables = {
      BROWSER = "qutebrowser";
      TERMINAL = "foot";
    };

    # --------------------------------
    # HOME PKGS
    # --------------------------------

    packages = with pkgs; [
      # - Network
      overskride # bluetooth gui
      bluetui # bluetooth tui
      qbittorrent # torrent client
      tor-browser
      # deltachat-desktop
      # fractal # matrix clietn
      vivaldi

      # - Media
      crosspipe # A GTK patchbay for pipewire
      pavucontrol # audio gui control
      flacon # gui split music cue
      alsa-utils # audio volume control (?)
      pulsemixer # cli pulse adudio control
      easyeffects # microphone effects
      # nomacs-qt6 # fast image viewer for RAW (no icc support)
      kdePackages.gwenview # imave viewer with icc support
      kdePackages.kimageformats # jxl and raw rendering
      obs-studio
      upscayl
      freefilesync
      # ascii-draw
      video-downloader
      losslesscut-bin # ffmpeg gui for lossless cut videos

      # - Theming
      vimix-icon-theme # cursor icon
      gowall # Tool to convert a Wallpaper's color scheme
      grc
      dconf-editor
      wev # key events in wayland
      gucharmap # character map
      imagemagick
      fontpreview # --preview-text "Привет, как дела, это просто тест шрифта!!! 1234567890?*# Just a test for my font."

      # - Utils
      cool-retro-term
      veracrypt
      cmatrix # matrix in terminal
      nwg-displays # gui for display setup
      sc-im # vim spreadsheet program for terminal
      exiftool
      fzy
      translate-shell
      bc # gnu calculator
      wego # weather api
      jq # json parser
      # https://github.com/ChrisBuilds/terminaltexteffects

      # - Docs
      simple-scan # gnome gui scanner
      pdfarranger # gnome pdf merge
      stellarium # astro map
      astroterm # astro map ASCII
      foliate # book reader
      epy # cli book reader
      tldr # community documentation
      russ # rss tui reader

      # -- Office
      # onlyoffice-desktopeditors
      libreoffice
      hunspell # spellcheck for LO
      hunspellDicts.ru-ru # spell check for LO
      hunspellDicts.en-us # spellcheck for LO

      # - Gaming
      # unstable.portablemc # minecraft cli launcher
      curseofwar # stategy cli game
      vitetris # tetris cli game
      chess-tui
    ];
  };

  # --------------------------------
  # HOME PROGRAMS
  # --------------------------------

  programs = {
    ripgrep.enable = true;
    fastfetch.enable = true;
    yt-dlp.enable = true;

    # ashell = {
    #   enable = true;
    #   systemd.enable = true;
    #   settings = {
    #     animations.enable = false;
    #     position = "Top";
    #     modules = {
    #       left = [
    #         "Workspaces"
    #         "MediaPlayer"
    #       ];
    #       center = ["WindowTitle"];
    #       right = [
    #         "KeyboardLayout"
    #         "SystemInfo"
    #         [
    #           "Tray"
    #           "Privacy"
    #           "Settings"
    #         ]
    #         "Tempo"
    #       ];
    #     };
    #     workspaces = {
    #       visibility_mode = "All";
    #       enable_workspace_filling = true;
    #       max_workspaces = 10;
    #     };
    #     settings = {
    #       battery_format = "Icon";
    #       peripheral_battery_format = "Icon";
    #       peripheral_indicators = {
    #         Specific = [
    #           "Gamepad"
    #           "Keyboard"
    #         ];
    #       };
    #     };
    #     keyboard_layout = {
    #       labels = {
    #         "English (US)" = "🇺🇸";
    #         "Russian" = "🏳️‍🌈";
    #       };
    #     };
    #     appearance = {
    #       scale_factor = 1.0;
    #     };
    #   };
    # };

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
}
