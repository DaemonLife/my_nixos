# check file mime type: xdg-mime query filetype [FILE]
# check mime type in yazi with TAB key if you use mime-ext plugin (mime by files extention)!

{ pkgs, config, lib, ... }: {

  home.packages = with pkgs; [
    dragon-drop
    bat
    eza
    glow
    ouch
    mediainfo
    imagemagick
    trash-cli
    ffmpeg-full
  ];

  programs.yazi = with config.lib.stylix.colors; {
    enable = true;
    enableZshIntegration = true;

    ###########################
    # INIT LUA
    ###########################

    initLua = ''
      require("session"):setup {
      	sync_yanked = true,
      }

      require("smart-enter"):setup {
        open_multi = true,
      }

      require("recycle-bin"):setup()

      th.git = th.git or {}
      th.git.modified_sign = "M"
      th.git.deleted_sign = "D"
      th.git.added_sign = "A"
      th.git.untracked_sign = "*"
      th.git.ignored_sign = "I"
      th.git.updated_sign = "U"
      require("git"):setup()
    '';

    ###########################
    # PLUGINS INSTALL
    ###########################

    # plugins support next code format: nixpkg_name = nixpkg_name;
    plugins = with pkgs.yaziPlugins; {
      mount = mount; # shorts: m-ount u-mount e-ject
      smart-enter = smart-enter; # enter to directories
      smart-filter = smart-filter; # cool search+filter
      git = git; # files git status
      piper = piper; # preview with shell commands
      # relative-motions = relative-motions; # vim keys
      ouch = ouch; # archive preview and compress
      recycle-bin = recycle-bin; # system trash bin support
      mediainfo = mediainfo;
      wl-clipboard = wl-clipboard;
      toggle-pane = toggle-pane;
      # mime-ext = mime-ext; # fast mime-type by file extencions
    };

    ###########################
    # MAIN SETTINGS
    ###########################

    settings = {
      floating_window_scaling_factor = 0.5;

      tasks = {
        image_alloc = 1073741824; # = 1024*1024*1024 = 1024MB
        image_bound = [ 0 0 ];
      };

      preview = {
        image_filter = "nearest"; # nearest (faster) or triangle (fast)
        image_quality = 60;
        max_width = 800;
        max_height = 800;
      };

      mgr = {
        sort_dir_first = true;
        title_format = "y {cwd}";
        linemode = "mtime";
      };

      ###########################
      # PLUGINS PREVIEW
      ###########################

      plugin = {
        prepend_fetchers = [
          # --- plugin mime-ext ---
          # { id = "mime"; name = "*"; run = "mime-ext"; prio = "high"; }

          # --- plugin git ---
          { id = "git"; name = "*"; run = "git"; }
          { id = "git"; name = "*/"; run = "git"; }
        ];

        prepend_preloaders = [ ]; # background loading

        prepend_previewers = [
          # --- plugin mediainfo --- (sad no image/jxl support)
          # { mime = "image/jxl"; run = ''magick''; prio = "high"; }
          { mime = "{audio,video,image}/*"; run = "mediainfo"; prio = "high"; }

          # --- Ouch archive previewer ---
          { mime = "application/*zip"; run = "ouch"; }
          { mime = "application/x-tar"; run = "ouch"; }
          { mime = "application/x-bzip2"; run = "ouch"; }
          { mime = "application/x-7z-compressed"; run = "ouch"; }
          { mime = "application/x-rar"; run = "ouch"; }
          { mime = "application/vnd.rar"; run = "ouch"; }
          { mime = "application/x-xz"; run = "ouch"; }
          { mime = "application/xz"; run = "ouch"; }
          { mime = "application/x-zstd"; run = "ouch"; }
          { mime = "application/zstd"; run = "ouch"; }
          { mime = "application/java-archive"; run = "ouch"; }

          # selected folder tree preview
          { name = "*/"; run = ''piper -- eza -TL=3 --color=always --icons=never --group-directories-first --no-quotes "$1"''; }

          # other
          { name = "*.csv"; run = ''piper -- bat -p --color=always "$1"''; }
          { name = "*.md"; run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"''; }
        ];
      };

      ###########################
      # OPENER RULES
      ###########################

      opener = {
        "edit" = [{
          run = ''$EDITOR "$@"'';
          desc = "Edit";
          block = true;
        }];
        "open" = [{
          run = ''xdg-open "$@"'';
          desc = "Open (xdg default)";
        }];
        "video" = [{
          run = ''mpv "$@" >/dev/null 2>&1 &'';
          desc = "Play video";
          block = true;
          orphan = true;
        }];
        "image" = [{
          run = ''gwenview "$@"'';
          desc = "Open in gwenview";
          orphan = true;
        }];
        "image-raw" = [{
          run = ''nomacs "$@"'';
          desc = "Open in nomacs";
          orphan = true;
        }];
        "librewolf" = [{
          run = ''librewolf "$@"'';
          desc = "Open in Librewolf";
          orphan = true;
        }];
        "qutebrowser" = [{
          run = ''qutebrowser "$@"'';
          desc = "Open in qutebrowser";
          orphan = true;
        }];
        "qbittorrent" = [{
          run = ''qbittorrent "$@"'';
          desc = "Open in qBittorrent";
          orphan = true;
        }];
        "rtorrent" = [{
          run = ''cp "$@" $HOME/Downloads/rtorrent/watch && kitty --hold sh -c "rtorrent"'';
          desc = "Open in rtorrent";
          orphan = true;
        }];
      };

      ###########################
      # OPENER FILES
      ###########################

      open = {
        prepend_rules = [
          { name = "*.{ARW,NEF}"; use = [ "image-raw" ]; }
          { mime = "image/*"; use = [ "image" ]; }
          { mime = "video/*"; use = [ "video" ]; }
          { name = "*.torrent"; use = [ "qbittorrent" "rtorrent" ]; }
          { mime = "text/html"; use = [ "qutebrowser" "librewolf" "edit" ]; }
          { mime = "text/plain"; use = [ "edit" ]; }
          { mime = "application/{octet-stream,java-applet,json}"; use = [ "edit" ]; }
          { mime = "*"; use = [ "edit" ]; }
        ];
      };
    };

    ###########################
    # COLOR THEME
    ###########################

    theme = lib.mkForce {
      tabs = {
        active = { fg = "#${base00}"; bg = "#${base0B}"; };
        inactive = { fg = "#${base03}"; bg = "#${base01}"; };
        sep_inner = { open = ""; close = ""; };
        sep_outer = { open = ""; close = ""; };
      };

      mgr = {
        border_symbol = "│";
        border_style = { fg = "#${base01}"; };
        count_copied = { fg = "#${base00}"; bg = "#${base0B}"; };
        count_cut = { fg = "#${base00}"; bg = "#${base08}"; };
        count_selected = { fg = "#${base00}"; bg = "#${base0A}"; };

        # Color block on the left side separator line in the filename.
        marker_copied = { bg = "#${base0B}"; fg = "#${base0B}"; };
        marker_cut = { bg = "#${base08}"; fg = "#${base08}"; };
        marker_marked = { bg = "#${base03}"; fg = "#${base03}"; }; # SEL/V mode
        marker_selected = { bg = "#${base0A}"; fg = "#${base0A}"; };
      };

      mode = {
        normal_main = { fg = "#${base00}"; bg = "#${base03}"; };
        normal_alt = { fg = "#${base04}"; bg = "#${base01}"; }; # file size info, etc
        select_main = { fg = "#${base00}"; bg = "#${base0F}"; };
        select_alt = { fg = "#${base04}"; bg = "#${base01}"; };
        unset_main = { fg = "#${base00}"; bg = "#${base0E}"; };
        unset_alt = { fg = "#${base04}"; bg = "#${base01}"; };
      };

      status = {
        sep_left = { open = ""; close = ""; };
        sep_right = { open = ""; close = ""; };
        overall = { fg = "#${base04}"; bg = "#${base01}"; };
      };

      icon = {
        globs = [ ];
        dirs = [ ];
        files = [ ];
        exts = [ ];
        conds = [ ];
        prepend_dirs = [{ name = "nix"; text = "*"; }];
      };
    };

    ###########################
    # KEYMAP SETUP
    ###########################

    keymap = {
      input.prepend_keymap = [
        { run = "escape"; on = [ "<Esc>" ]; }
      ];
      mgr.prepend_keymap = [
        # go to folder
        {
          on = [ "g" "d" ];
          run = "cd ~/Downloads";
        }
        {
          on = [ "g" "v" ];
          run = "cd ~/Videos";
        }
        {
          on = [ "g" "N" ];
          run = "cd ~/Documents/Notes";
        }
        {
          on = [ "g" "n" ];
          run = "cd ~/nix";
        }
        {
          on = [ "п" "в" ]; # ru
          run = "cd ~/Downloads";
        }
        {
          on = [ "п" "м" ]; # ru
          run = "cd ~/Videos";
        }
        {
          on = [ "п" "Т" ]; # ru
          run = "cd ~/Documents/Notes";
        }
        {
          on = [ "п" "т" ]; # ru
          run = "cd ~/nix";
        }
        # open shell here
        {
          on = "<C-s>";
          run = ''shell "$SHELL" --block'';
          desc = "Open $SHELL here";
        }
        {
          on = "<C-ы>";
          run = ''shell "$SHELL" --block'';
          desc = "Open $SHELL here";
        }
        # plugin system clipboard support
        {
          on = "Y";
          run = [ "plugin wl-clipboard" ];
          desc = "Copy to system clipboard";
        }
        {
          on = "Н"; # ru
          run = [ "plugin wl-clipboard" ];
          desc = "Copy to system clipboard";
        }
        # plugin toggle pane
        {
          on = "T";
          run = [ "plugin toggle-pane min-preview" ];
          desc = "Show or hide the preview pane";
        }
        {
          on = "Е"; # ru
          run = [ "plugin toggle-pane min-preview" ];
          desc = "Show or hide the preview pane";
        }
        # plugin drag and drop
        {
          on = "<C-g>";
          run = ''
            shell --interactive '${pkgs.dragon-drop}/bin/dragon-drop -x -i -T "$1"'
          '';
        }
        {
          on = "<C-п>"; # ru
          run = ''
            shell --interactive '${pkgs.dragon-drop}/bin/dragon-drop -x -i -T "$1"'
          '';
        }
        # plugin mount
        {
          on = "M";
          run = "plugin mount";
          desc = "Mount partitions";
        }
        {
          on = "Ь"; # ru
          run = "plugin mount";
          desc = "Mount partitions";
        }
        # plugin smart enter
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "д"; # ru
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "Enter";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        # plugin smart filter
        {
          on = "?";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        # plugin compress
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = [ "С" ]; # ru
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        # plugin recycle-bin
        {
          on = [ "b" "o" ];
          run = "plugin recycle-bin -- open";
          desc = "Open trash";
        }
        {
          on = [ "b" "e" ];
          run = "plugin recycle-bin -- empty";
          desc = "Empty trash";
        }
        {
          on = [ "b" "D" ];
          run = "plugin recycle-bin -- emptyDays";
          desc = "Empty trash by [DAYS]";
        }
        {
          on = [ "b" "d" ];
          run = "plugin recycle-bin -- delete";
          desc = "Remove completely";
        }
        {
          on = [ "b" "r" ];
          run = "plugin recycle-bin -- restore";
          desc = "Restore";
        }

        ###### other default rus ######
        {
          on = "Р";
          run = "back";
          desc = "Back to previous directory";
        }
        {
          on = "Д";
          run = "forward";
          desc = "Forward to next directory";
        }
        {
          on = "р";
          run = "leave";
          desc = "Back to parent directory";
        }
        {
          on = "л";
          run = "arrow prev";
          desc = "Previous file";
        }
        {
          on = "о";
          run = "arrow next";
          desc = "Next file";
        }
        {
          on = "й";
          run = "quit";
          desc = "ru: quit";
        }
        {
          on = "м";
          run = "visual_mode";
          desc = "ru: visual mode enter";
        }
        {
          on = "н";
          run = "yank";
          desc = "ru: yank";
        }
        {
          on = "Н";
          run = "unyank";
          desc = "ru: unyank";
        }
        {
          on = "ч";
          run = "yank --cut";
          desc = "ru: cut";
        }
        {
          on = "Ч";
          run = "unyank";
          desc = "ru: uncut";
        }
        {
          on = "з";
          run = "paste";
          desc = "ru: paste";
        }
        {
          on = "в";
          run = "remove";
          desc = "ru: trash";
        }
        {
          on = "В";
          run = "remove --permanently";
          desc = "ru: delete";
        }
        {
          on = "е";
          run = "tab_create --current";
          desc = "Create a new tab with CWD";
        }
        {
          on = "ц";
          run = "tasks:show";
          desc = "Show task manager";
        }
      ];
    };
  };
}
