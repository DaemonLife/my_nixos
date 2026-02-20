{ pkgs, config, ... }: {
  programs.fish = with config.lib.stylix.colors; {
    enable = true;

    shellAliases = {
      # os help - for help
      os = "$HOME/nix/scripts/nix_rebuild.sh";

      gitp = ''
        git add .
        set msg (string join " " $argv)
        git commit -m "$msg"
        git push && echo "Push complited!"
      '';

      # battery configuration will be restored at the next boot
      tlp-set-full-bat = "sudo tlp fullcharge bat1";
      tlp-set-conserv-bat = "sudo tlp setcharge bat1";
      cmus-connect-phone = "eval (ssh-agent -c) && ssh-add ~/.ssh/termux && sshfs -p 8022 u0_a183@192.168.0.190:/data/data/com.termux/files/home/storage/music/my ~/Music/termux_music/";
    };

    shellAbbrs = {
      jrnl = " jrnl";
      jrnl-tags = ''
         set tag "боль"
        jrnl --format json | jq -r --arg tag "@$tag" '
          .entries[]
          | select((.tags // []) | map(startswith($tag)) | any)
          | "\(.date) \((.tags // [] | map(select(startswith($tag))) | join(" ")))"
        '
      '';
      yt-dlp-best = ''yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"''; # add URL
    };

    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "grc"; # colored output for some command (lsblk for example)
        src = pkgs.fishPlugins.grc.src;
      }
    ];

    # when login to shell
    loginShellInit = ''
      if not set -q DISPLAY
        if test (tty) = "/dev/tty1"
          # echo "Run niri-session"
          # bash $HOME/nix/scripts/start_niri.sh
          # niri-session
          # exec uwsm start hyprland-uwsm.desktop
          WLR_RENDERER=vulkan exec sway
        end
      end
    '';

    # when start shell
    # git status for my promt, check:
    # https://fishshell.com/docs/current/cmds/fish_git_prompt.html
    shellInit = ''
      set __fish_git_prompt_show_informative_status 1
      set ___fish_git_prompt_char_cleanstate v
      set ___fish_git_prompt_char_dirtystate ⁕
      set ___fish_git_prompt_char_invalidstate x
      # set ___fish_git_prompt_char_stagedstate ⸱
      set ___fish_git_prompt_char_stagedstate +
      set ___fish_git_prompt_char_stashstate 🏴
      set ___fish_git_prompt_char_stateseparator '|'
      set ___fish_git_prompt_char_untrackedfiles …
      set ___fish_git_prompt_char_upstream_ahead ⇡
      set ___fish_git_prompt_char_upstream_behind ⇣
      set ___fish_git_prompt_char_upstream_diverged '<>'

      set -g fish_key_bindings fish_vi_key_bindings # vim mode
      set fish_cursor_insert line blink # for vi mode
      # bind -s --preset -M visual -m default space-y "fish_clipboard_copy; commandline -f end-selection repaint-mode"

      bind yy fish_clipboard_copy
      bind Y fish_clipboard_copy
      bind p fish_clipboard_paste

      # rust bin
      set PATH $HOME/.cargo/bin $PATH
    '';

    functions = {
      # disable it
      fish_greeting = "bash $HOME/nix/scripts/print_art.sh";

      fish_prompt = ''
        printf '%s@%s %s%s%s%s \n> ' $USER $hostname (set_color $fish_color_cwd) $PWD (set_color normal) (fish_vcs_prompt)
      '';

      # yazi setup
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        	builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
  };
}
