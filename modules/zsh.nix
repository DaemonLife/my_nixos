{ pkgs, config, lib, ... }: {

programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellAliases = {
        # nix aliases
        flake-rebuild = "\
        sudo nixos-rebuild switch --flake \"$HOME/nix/.\" && \
        echo '\n> Complited. The flake has been rebuilded.'";
        flake-upgrade = "\
        sudo nix-channel --update && \
        echo '\n> Nix-channel has been updated.\n' && \
        sudo nix flake update \"$HOME/nix/.\" && \
        echo '\n> Flake has been updated.\n' && flake-rebuild";
        home-rebuild = "\
        home-manager switch --flake \"$HOME/nix/.\" && hyprctl reload && \
        echo '> Home-manager has been switch. Hyprland reloaded.'";

        update = "nh os switch $HOME/nix/.";
        upgrade = "
        sudo nix-channel --update && \
        echo '\n> Nix-channel has been updated.\n' && \
        sudo nix flake update --flake \"$HOME/nix/.\" && \
        echo '\n> Flake has been updated.\n' && update";
       
        # for windows fs
        cdwin = "source $HOME/nix/scripts/cdwin.sh";

        # battery configuration will be restored at the next boot
        tlp_full = "sudo tlp fullcharge bat1";
        tlp_conserv = "sudo tlp setcharge bat1";
    };

    oh-my-zsh = {
        enable = true;
        plugins = [
            "web-search"
            "git"
        ];
    };
    
    # my theme for zsh + oh-my-zsh
    initExtra = ''
      source $HOME/nix/themes/my.zsh-theme;
    '';
};

home.file."$HOME/nix/themes/my.zsh-theme".text = ''
PROMPT=$'
%{$fg[blue]%}%/%{$reset_color%} $(git_prompt_info)$(bzr_prompt_info)%{$fg[white]%}[%n@%m]%{$reset_color%} %{$fg[white]%}[%T]%{$reset_color%}
%{$fg_bold[white]%}>%{$reset_color%} '

PROMPT2="%{$fg_bold[white]%}%_> %{$reset_color%}"

GIT_CB="git::"
ZSH_THEME_SCM_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_PREFIX=$ZSH_THEME_SCM_PROMPT_PREFIX$GIT_CB
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
'';

}
