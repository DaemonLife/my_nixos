{ pkgs, config, ... }: {
  home.packages = with pkgs; [ libnotify ];

  # notify-send "Test messange from shell"
  services.mako = {
    enable = true;
    settings = {
      layer = "overlay";
      anchor = "top-right";
      width = 500;
      height = 300;
      icons = true;
      markup = true;
      margin = "4,4,4,4";
      padding = "12,10,12,10";
      border-size = config.wayland.windowManager.sway.config.window.border;
      border-radius = 0;
      default-timeout = 12000;
      group-by = "summary";
      # format = "<b>%s</b>\\n%b";
      format = "<b>%a</b>\\n%s\\n%b";
      "mode=dnd" = { invisible = 1; };
      # makoctl mode -a dnd - add mode
      # makoctl mode -r dnd - remove mode
    };
  };
}
