{ pkgs, config, ... }:
let
  gtk_colors = with config.colorScheme.palette; ''
    @define-color accent_color #${base0D};
    @define-color accent_bg_color #${base0D};
    @define-color accent_fg_color #${base02}; 
    @define-color destructive_color #${base08};
    @define-color destructive_bg_color #${base09};
    @define-color destructive_fg_color #${base0A};
    @define-color success_color #${base0B};
    @define-color success_bg_color #${base0B};
    @define-color success_fg_color #${base05};
    @define-color warning_color #${base09};
    @define-color warning_bg_color #${base09};
    @define-color warning_fg_color #${base05};
    @define-color error_color #${base08};
    @define-color error_bg_color #${base08};
    @define-color error_fg_color #${base05};
    @define-color window_bg_color #${base00};
    @define-color window_fg_color #${base05};
    @define-color view_bg_color #${base00};
    @define-color view_fg_color #${base05};
    @define-color headerbar_bg_color #${base00};
    @define-color headerbar_fg_color #${base05};
    @define-color headerbar_border_color #${base00};
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color headerbar_shade_color #${base00};
    @define-color sidebar_bg_color #${base01};
    @define-color sidebar_fg_color #${base05};
    @define-color sidebar_border_color #${base01};
    @define-color sidebar_backdrop_color @window_bg_color;
    @define-color sidebar_shade_color #${base00};
    @define-color card_bg_color #${base00};
    @define-color card_fg_color #${base05};
    @define-color card_shade_color #${base00};
    @define-color dialog_bg_color #${base00};
    @define-color dialog_fg_color #${base05};
    @define-color popover_bg_color #${base00};
    @define-color popover_fg_color #${base05};
    @define-color shade_color #${base00};
    @define-color scrollbar_outline_color #${base05};
    @define-color blue_1 #${base0C};
    @define-color blue_2 #${base0C};
    @define-color blue_3 #${base0D};
    @define-color blue_4 #${base0D};
    @define-color blue_5 #${base0D};
    @define-color green_1 #${base0B};
    @define-color green_2 #${base0B};
    @define-color green_3 #${base0B};
    @define-color green_4 #${base0B};
    @define-color green_5 #${base0B};
    @define-color yellow_1 #${base0A};
    @define-color yellow_2 #${base0A};
    @define-color yellow_3 #${base0A};
    @define-color yellow_4 #${base0A};
    @define-color yellow_5 #${base0A};
    @define-color orange_1 #${base09};
    @define-color orange_2 #${base09};
    @define-color orange_3 #${base09};
    @define-color orange_4 #${base09};
    @define-color orange_5 #${base09};
    @define-color red_1 #${base08};
    @define-color red_2 #${base08};
    @define-color red_3 #${base08};
    @define-color red_4 #${base08};
    @define-color red_5 #${base08};
    @define-color purple_1 #${base0E};
    @define-color purple_2 #${base0E};
    @define-color purple_3 #${base0E};
    @define-color purple_4 #${base0E};
    @define-color purple_5 #${base0E};
    @define-color brown_1 #${base0F};
    @define-color brown_2 #${base0F};
    @define-color brown_3 #${base0F};
    @define-color brown_4 #${base0F};
    @define-color brown_5 #${base0F};
    @define-color light_1 #${base07};
    @define-color light_2 #${base06};
    @define-color light_3 #${base05};
    @define-color light_4 #${base04};
    @define-color light_5 #${base03};
    @define-color dark_1 #${base02};
    @define-color dark_2 #${base02};
    @define-color dark_3 #${base01};
    @define-color dark_4 #${base01};
    @define-color dark_5 #${base00};
  '';
in {

  gtk = with config.colorScheme.colors; {
    enable = true;
    # cursorTheme.name = "Qogir-dark";
    iconTheme.name = "Vimix";
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk3.extraConfig = {
      # gtk-theme-name = "Adwaita-dark";
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraCss = gtk_colors;
    gtk3.extraCss = gtk_colors;

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
  };
}
