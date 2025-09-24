{
  pkgs,
  config,
  ...
}: {
  programs.fish = with config.lib.stylix.colors; {
    enable = true;

    shellAliases = {
      # os help - for help
      os = "$HOME/nix/scripts/nix_rebuild.sh";

      # for windows fs on lenovo
      mwin = "$HOME/nix/scripts/cdwin.fish && cd /mnt/windows/Users/user";

      # battery configuration will be restored at the next boot
      tlp_full = "sudo tlp fullcharge bat1";
      tlp_conserv = "sudo tlp setcharge bat1";
    };

    shellAbbrs = {
      jrnl = " jrnl"; # hide from shell history
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
      set -g fish_key_bindings fish_vi_key_bindings # vim mode

      set __fish_git_prompt_show_informative_status 1
      set fish_cursor_insert line blink # for vi mode
      # bind -s --preset -M visual -m default space-y "fish_clipboard_copy; commandline -f end-selection repaint-mode"

      bind yy fish_clipboard_copy
      bind Y fish_clipboard_copy
      bind p fish_clipboard_paste
    '';

    functions = {
      # disable it
      fish_greeting = "";

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
