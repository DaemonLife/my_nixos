{ config
, lib
, ...
}: {
  programs.foot = with config.lib.stylix.colors; {
    enable = true;

    settings = {
      main = {
        selection-target = "both"; # copy to foot and system clipboard
        dpi-aware = lib.mkForce "no";
        pad = "5x5";
        resize-by-cells = "no";
        # font = lib.mkForce [
        # "Unifont:append:size=${toString config.stylix.fonts.sizes.terminal}"
        # "Unifont Upper:prepend:size=${toString config.stylix.fonts.sizes.terminal}"
        # "Unifont CSUR:prepend:size=${toString config.stylix.fonts.sizes.terminal}"
        # ];
      };
      key-bindings = {
        scrollback-up-line = "Control+Shift+k";
        scrollback-down-line = "Control+Shift+j";
      };

      cursor = {
        beam-thickness = 1.2;
      };
    };
  };
}
