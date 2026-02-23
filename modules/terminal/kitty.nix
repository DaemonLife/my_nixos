{ config, lib, ... }: {
  programs.kitty = with config.lib.stylix.colors; {
    enable = true;
    # shellIntegration.enableZshIntegration = true;
    shellIntegration.enableFishIntegration = true;

    keybindings = {
      "ctrl+shift+c" = "copy_or_interrupt";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+с" = "copy_or_interrupt";
      "ctrl+shift+м" = "paste_from_clipboard";
    };

    settings = {
      shell = "fish";
      enable_audio_bell = false;
      visual_bell_duration = "0.1";
      open_url_with = "$BROWSER";
      editor = "$EDITOR";
      # linux_display_server = "wayland"; # disable for x11
      # window_border_width = "0px"; # disable for x11
      # hide_window_decorations = "yes"; # disable for x11
      window_margin_width = "0 0 0 0";
      window_padding_width = "4 4 4 4";
      tab_bar_style = "hidden";
      confirm_os_window_close = "0";
      # inactive_text_alpha = "0.5";
      # cursor_trail = 2;
    };

    # visual bell works only this way.
    # modify font for unifont fix
    extraConfig = ''
      visual_bell_color #${base01} 
      modify_font cell_width 50% 
    '';
  };
}
