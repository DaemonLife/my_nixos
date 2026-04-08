{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    typer
  ];

  home.file.".typer.yaml".text = with config.lib.stylix.colors; ''
    theme:
      bar:
        color: '#${base0B}' # basic color of the progressbar
        gradient: '#${base0C}' # if passed, will generate a gradient from previous color to this one
        background: '#${base0E}'
      graph:
        # see: https://pkg.go.dev/github.com/guptarohit/asciigraph#AnsiColor
        # see: https://github.com/guptarohit/asciigraph/blob/master/color.go#L152-L292
        color: silver # does not use rgb but rather ANSI codes
        height: 4   # height of the graph
      text:
        error: # color when misspelled
          background: '#${base08}'
          foreground: '#${base00}'
        typed: # color when character have been typed
          foreground: '#${base0B}'
          #background: '#000' # optional, default theme does not add background
        untyped: # color when still haven't been typed
          foreground: '#${base06}'
          #background: '#000' # optional, default theme does not add background
  '';
}
