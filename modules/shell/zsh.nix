{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins"; # viins vicmd emacs

    prezto = {
      enable = true;
      editor.keymap = "vi";
      prompt.theme = "giddie";
    };

    history = {
      size = 10000;
      ignorePatterns = ["jrnl *"];
      path = "${config.xdg.dataHome}/zsh/history";
    };

    envExtra = let
      # lol
      var1 = "\${NNNLVL:-0}";
      var2 = "$\{XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd";
    in ''
      # some options
      # bash $HOME/nix/scripts/print_art.sh
      export PATH="$HOME/.cargo/bin:$PATH"
      export PROXYCHAINS_SOCKS5_PORT=20170
      eval "$(ssh-agent -s)" > /dev/null
      ssh-add ~/.ssh/github 2> /dev/null
      ssh-add ~/.ssh/termux 2> /dev/null

      # nnn function (n alias)
      n (){
        export NNN_TRASH=1 # nnn trash-cli support
        [ "${var1}" -eq 0 ] || {
          echo "nnn is already running"
          return
        }
        export NNN_TMPFILE="${var2}"
        command nnn -C -R "$@" # 8 bit color, disable rollover
        [ ! -f "$NNN_TMPFILE" ] || {
          . "$NNN_TMPFILE"
          rm -f -- "$NNN_TMPFILE" > /dev/null
        }
      }
    '';

    # shell indicator for nnn
    initContent = ''
      [ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"
    '';

    loginExtra = ''
      if [[ -z $DISPLAY ]]; then
        if [[ $(tty) == "/dev/tty1" ]]; then
          start-hyprland
          # WLR_RENDERER=vulkan sway
          # exec sway
        fi
      fi
    '';

    shellAliases = {
      # --upgrade --offline
      "oss" = ''nix flake update --flake $HOME/nix/. && sudo nixos-rebuild switch --flake $HOME/nix/.\#lenovo -v'';
      "osb" = ''nix flake update --flake $HOME/nix/. && sudo nixos-rebuild boot --flake $HOME/nix/.\#lenovo -v'';
      "ost" = ''sudo nixos-rebuild test --flake $HOME/nix/.\#lenovo -v'';
      "osc" = ''sudo nix-collect-garbage --delete-older-than 3d'';

      # --- Other ---
      tt = "tt --notheme --highlight1 --blockcursor";
      ffmpeg-video-compress = "bash $HOME/nix/scripts/ffmpeg-video-compress.sh";
      lf = ''cd "`bash -c "lf -print-last-dir"`"'';
      ncdu = "ncdu -t8"; # use 8 cores

      wifi-off = "nmcli r all off && nmcli r";
      wifi-on = "nmcli r all off && nmcli r";
    };

    siteFunctions = {
      gitp = ''
        git add -A
        git commit -m "$*"
        git push && echo "Push completed!"
      '';

      y = ''
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      '';

      trr = ''trans :ru -show-original-phonetics n -show-translation-phonetics n -show-prompt-message n -show-alternatives n -show-original n "$*" && echo '';
      tre = ''trans :en -show-original-phonetics n -show-translation-phonetics n -show-prompt-message n -show-alternatives n -show-original n "$*" && echo '';
    };
  };

  # home.file.".config/zsh/my.zsh-theme".text = ''
  #   PROMPT=$'%{$fg[green]%}%/%{$reset_color%} $(git_prompt_info)$(bzr_prompt_info)%{$fg[white]%}[%n@%m]%{$reset_color%} %{$fg[white]%}[%T]%{$reset_color%}
  #   %{$fg[white]%}>%{$reset_color%} '
  #
  #   PROMPT2="%{$fg_bold[white]%}%_> %{$reset_color%}"
  #
  #   GIT_CB="git::"
  #   ZSH_THEME_SCM_PROMPT_PREFIX="%{$fg[green]%}["
  #   ZSH_THEME_GIT_PROMPT_PREFIX=$ZSH_THEME_SCM_PROMPT_PREFIX$GIT_CB
  #   ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
  #   ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
  #   ZSH_THEME_GIT_PROMPT_CLEAN=""
  # '';
}
