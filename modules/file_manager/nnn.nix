{config, ...}: {
  programs.nnn = with config.lib.stylix.colors; {
    enable = true;
  };
}
