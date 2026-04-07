{
  config,
  lib,
  pkgs,
  ...
}:
with config.lib.stylix.colors; let
  cli-chess_style = let
    black = "#${base00}";
    darkgray = "#${base01}";
    gray = "#${base02}";
    darkwhite = "#${base04}";
    white = "#${base06}";
    brightwhite = "#${base07}";
    red = "#${base08}";
    orange = "#${base0A}";
    yellowgreen = "#${base0B}";
    green = "#${base0C}";
    cyan = "#${base0D}";
    magenta = "#${base0E}";
  in ''
    # Restarting cli-chess or pressing [CTRL+R] on any screen will force a style refresh.
    {
      "rank-label": "fg:${gray}",
      "file-label": "fg:${gray}",
      "light-square": "bg:${darkwhite}",
      "light-square.light-piece": f"fg:${brightwhite}",
      "light-square.dark-piece": f"fg:${black}",
      "dark-square": "bg:${gray}",
      "dark-square.light-piece": f"fg:${brightwhite}",
      "dark-square.dark-piece": f"fg:${black}",
      "last-move": "bg:${yellowgreen}",
      "last-move.light-piece": f"fg:${white}",
      "last-move.dark-piece": f"fg:${black}",
      "pre-move": "bg:${orange}",
      "pre-move.light-piece": f"fg:${white}",
      "pre-move.dark-piece": f"fg:${black}",
      "in-check": "bg:${magenta}",
      "in-check.light-piece": f"fg:${white}",
      "in-check.dark-piece": f"fg:${black}",
      "material-difference": "fg:${gray}",
      "move-list": "fg:${gray}",
      "move-input": "fg:${brightwhite}",
      "player-info": "fg:${white}",
      "player-info.title": "fg:${orange}",
      "player-info.title.bot": "fg:${magenta}",
      "player-info.pos-rating-diff": "fg:${green}",
      "player-info.neg-rating-diff": "fg:${red}",
      "clock": "fg:${white}",
      "clock.ticking": "bg:${green}",

      # Program styling
      "menu": "bg:",
      "menu.category-title": "fg:${black} bg:${green}",
      "menu.option": "fg:${white}",
      "menu.multi-value": "fg:${orange}",
      "focused-selected": "fg:${black} bg:mediumturquoise noinherit",
      "unfocused-selected": "fg:${black} bg:${white} noinherit",
      "menu.multi-value focused-selected": "fg:${orange} noinherit",
      "menu.multi-value unfocused-selected": "fg:${orange} noinherit",
      "function-bar.key": "fg:${white}",
      "function-bar.label": "fg:${black} bg:${cyan}",
      "function-bar.spacer": "",
      "label": "fg:${white}",
      "label.dim": "fg:${darkgray}",
      "label.success": "fg:${green}",
      "label.error": "fg:${red}",
      "label.success.banner": "bg:${green} fg:${white}",
      "label.error.banner": "bg:${red} fg:${white}",
      "label.neutral.banner": "bg:${gray} fg:${white}",
      "text-area.input": "fg:${orange}",
      "text-area.input.placeholder": "italic",
      "text-area.prompt": "fg:${white} bg:${cyan}",
      "validation-toolbar": "fg:${white} bg:${red}",
    }
  '';
in {
  home.packages = with pkgs; [
    (writeShellScriptBin "chess" (builtins.readFile ./nix-shell/run_chess.sh))
  ];
  home.activation.cli-chess_style = lib.hm.dag.entryAfter ["writeBoundary"] ''

    mkdir -p $HOME/.config/cli-chess
    cd $HOME/.config/cli-chess
    echo '${cli-chess_style}' > custom_style.py;

  '';
}
