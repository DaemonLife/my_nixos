{ pkgs, config, lib, ... }:
with config.lib.stylix.colors; {

  # hyprland settings
  wayland.windowManager.hyprland.settings = {

    general = {
      border_size = lib.mkForce 2;
      gaps_in = lib.mkForce 0;
      gaps_out = lib.mkForce "0, 0, 0, 0";
    };

    input = {
      sensitivity = lib.mkForce "-0.2"; # -1.0 - 1.0
      scroll_factor = lib.mkForce "0.5";

      touchpad = {
        scroll_factor = lib.mkForce "0.000000005";
        disable_while_typing = lib.mkForce true;
        tap-and-drag = lib.mkForce false;
        drag_lock = lib.mkForce false;
      };

      # correct touch map for gpd screen
      touchdevice.transform = lib.mkForce 3;
    };

    monitor = [
      "DSI-1,preferred,auto-left,1.87500,transform,3"
    ];

    # plugin = {
    #   touch_gestures = {
    #     sensitivity = 3.0;
    #     long_press_delay = 170;
    #     edge_margin = 500;
    #   };
    # };

  };

}
