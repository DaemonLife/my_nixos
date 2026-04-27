{ config, lib, ... }: {

  programs.fzf = with config.lib.stylix.colors; {
    enable = true;
    enableZshIntegration = true;

    colors = lib.mkForce {
      fg = "#${base07}";
      "fg+" = "#${base07}";
      bg = "#${base00}";
      "bg+" = "#${base00}";
      preview-fg = "#${base05}";
      preview-bg = "#${base01}";
      hl = "#${base0D}";
      "hl+" = "#${base0D}";
      gutter = "#${base08}";
      info = "#${base0B}";
      border = "#${base07}";
      prompt = "#${base03}";
      pointer = "#${base05}";
      marker = "#${base09}";
      spinner = "#${base0E}";
      header = "#${base0A}";
    };

  };
}
