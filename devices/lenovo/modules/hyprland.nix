{ pkgs, config, lib, ... }:
with config.lib.stylix.colors; {

  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = lib.mkForce 3;
      gaps_out = lib.mkForce "6, 6, 6, 6";
    };

    input = {
      sensitivity = lib.mkForce "0"; # -1.0 - 1.0
      scroll_factor = lib.mkForce "1.0";
    };

    monitor = [
      # Lenovo
      "eDP-1,highres,auto-right,2,bitdepth,10,vrr,1,mirror,desc:LG Electronics LG TV 0x01010101"
      # Monitor msk
      "desc:Shenzhen KTC Technology Group H27S17 0x00000001,2560x1440@75Hz,0x0,1.25,bitdepth,10,vrr,0"
      # Monitor gg
      "desc:Acer Technologies Acer A231H LQT0W0084320,highres,auto-right,1,bitdepth,10,vrr,1"
      # Random monitor
      ",preferred,auto,1"
    ];

  };

}
