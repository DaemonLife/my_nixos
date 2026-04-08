{ config, ... }: {

  programs.ranger = with config.lib.stylix.colors; {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = "kitty";
      draw_borders = "both";
    };
  };
}
