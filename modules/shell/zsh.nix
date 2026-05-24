{
  pkgs,
  config,
  lib,
  ...
}: {
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

    initContent = '''';
    shellGlobalAliases = {};
    shellAliases = let
      myphone_port = "8022";
      myphone_username = "u0_a231";
    in {
      # --- Rebuild ---
      # "oss" = ''nix flake update --flake $HOME/nix/. && sudo nixos-rebuild switch --flake $HOME/nix/.\#lenovo'';
      # "osb" = ''nix flake update --flake $HOME/nix/. && sudo nixos-rebuild boot --flake $HOME/nix/.\#lenovo'';
      "oss" = ''sudo nixos-rebuild switch --flake $HOME/nix/.\#lenovo -v''; # --upgrade --offline
      "osb" = ''sudo nixos-rebuild boot --flake $HOME/nix/.\#lenovo -v'';
      "ost" = ''sudo nixos-rebuild test --flake $HOME/nix/.\#lenovo -v'';
      "osc" = ''sudo nix-collect-garbage --delete-older-than 3d'';
      # os = "$HOME/nix/scripts/nix_rebuild.sh"; # os help - for help

      # --- Tlp ---
      tlp-set-full-bat = "sudo tlp fullcharge bat1";
      tlp-set-conserv-bat = "sudo tlp setcharge bat1";

      # --- Net ---
      # Openwrt static IP and hostname: Network → DHCP and DNS → Static Leases
      myphone-cmus = "bash $HOME/nix/scripts/myphone-cmus.sh ${myphone_username} ${myphone_port}";
      myphone-ssh = "ssh -p ${myphone_port} ${myphone_username}@myphone";
      # "-ignorelocks" for termux because https://github.com/omeyenburg/unison-for-termux
      myphone-sync = "bash $HOME/nix/scripts/myphone-sync.sh ${myphone_username} ${myphone_port}";

      # --- Other ---
      tt = "tt --notheme --highlight1 --blockcursor";
      cdwin = "bash $HOME/nix/scripts/mount_windows.sh '/dev/nvme0n1p3' 'user' && cd /mnt/windows/Users/user";
    };

    siteFunctions = {
      gitp = ''
        git add -A
        git commit -m "$*"
        git push
        echo "Push completed!"
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
