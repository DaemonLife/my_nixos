{ pkgs, config, lib, ... }: {

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins"; # viins vicmd emacs
    history = {
      size = 10000;
      ignorePatterns = [ "jrnl *" ];
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellGlobalAliases = { }; # substituted anywhere on a line
    shellAliases =
      let
        myphone_port = "8025";
        myphone_username = "u0_a345";
      in
      {
        os = "$HOME/nix/scripts/nix_rebuild.sh"; # os help - for help
        tt = "tt --notheme --highlight1 --blockcursor";

        # battery configuration will be restored at the next boot
        tlp-set-full-bat = "sudo tlp fullcharge bat1";
        tlp-set-conserv-bat = "sudo tlp setcharge bat1";

        # Openwrt static IP and hostname: Network → DHCP and DNS → Static Leases 
        myphone-connect-cmus = "bash $HOME/nix/scripts/myphone-connect-cmus.sh ${myphone_port} ${myphone_username}";
        myphone-ssh = "ssh -p ${myphone_port} ${myphone_username}@myphone";
        # "-ignorelocks" for termux because https://github.com/omeyenburg/unison-for-termux
        myphone-sync-notes = "unison -ignorelocks $HOME/Documents/Notes ssh://${myphone_username}@myphone:${myphone_port}//data/data/com.termux/files/home/Notes";
      };

    siteFunctions = {
      gitp = ''
        git add $(git rev-parse --show-toplevel)/.
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

    };

    prezto = {
      enable = true;
      editor.keymap = "vi";
      prompt.theme = "giddie";
    };

    initContent = ''
      PATH="$HOME/.cargo/bin $PATH"
    '';
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
