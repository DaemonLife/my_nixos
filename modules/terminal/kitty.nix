{ config, lib, ... }: {
  programs.kitty = with config.lib.stylix.colors; {
    enable = true;
    # shellIntegration.enableZshIntegration = true;
    shellIntegration.enableFishIntegration = true;

    # font = lib.mkForce {
    #   name = "UnifontExMono";
    # };

    keybindings = {
      "ctrl+shift+c" = "copy_or_interrupt";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+с" = "copy_or_interrupt";
      "ctrl+shift+м" = "paste_from_clipboard";
    };

    settings = {
      shell = "fish";
      editor = "$EDITOR";
      # linux_display_server = "wayland";
      enable_audio_bell = false;
      visual_bell_duration = "0.1";
      hide_window_decorations = "yes";
      # window_title = "Kitty";
      open_url_with = "$BROWSER";
      window_border_width = "0px";
      window_margin_width = "0 0 0 0";
      window_padding_width = "4 4 4 4";
      # inactive_text_alpha = "0.5";
      tab_bar_style = "hidden";
      confirm_os_window_close = "0";
      # cursor_trail = 2;
    };
    # For Stylix
    # it's important change colors only in extaConfig!
    extraConfig = ''
      visual_bell_color #${base01}
    '';
  };
}
