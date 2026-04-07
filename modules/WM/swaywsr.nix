{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swaywsr
  ];

  home.activation.swaywsr_config = let
    # swaymsg -t get_tree - show window's app_id and class
    config = ''
      [icons]

      [aliases]
      "Org.gnome.Nautilus" = "fs"
      "org.qbittorrent.qBittorrent" = "torrent"
      "vi" = "vi"
      "org.telegram.desktop" = "tg"
      "librewolf" = "net"
      "kitty" = "$"
      "foot" = "$"
      "qutebrowser" = "qb"
      "org.qutebrowser.qutebrowser" = "qb"
      "vpn_qutebrowser" = "vpn_qb"
      "thunar" = "fs"
      "y." = "y"

      [general]
      separator = " "
      ignore-char = "#"

      [options]
      no-names = true
      remove-duplicates = true
    '';
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.config/swaywsr"
      echo '${config}' > "$HOME/.config/swaywsr/config.toml"
    '';
}
