{ lib
, pkgs
, ...
}:
let
  conf = ''
    fallback = '*'
    separator = '-'

    [matching]
    # top priority /\
    # low priority \/

    # by title
    '/^.* - cmus$/' = 'cmus'
    '/^man .*$/' = 'man'
    '/^btop .*$/' = 'btop'
    '/^htop .*$/' = 'htop'
    'org.telegram.desktop' = 'tg'
    'com.ayugram.desktop' = 'tg'
    'org.qutebrowser.qutebrowser' = 'qb'
    'org.qbittorrent.qBittorrent' = 'torrent'
    '/^.*[Ss]team.*$/' = 'steam'
    '/^vi.*$/' = 'vi'
    '/^.*Nvim$/' = 'vi'
    '/^nvim$/' = 'vi'
    '/^y .*$/' = 'y'
    '/^rtorrent.*$/' = 'rtorrent'
    '/^.*Firefox$/' = 'firefox'
    '/^AmneziaVPN$/' = 'vpn'

    # by app id
    'librewolf' = 'librewolf'
    'Upscayl' = 'upscayl'
    'darktable' = 'darktable'
    'foot' = '$'
    'mpv' = 'mpv'
    'Mindustry' = 'mindustry'
    'org.kde.kdenlive' = 'kdenlive'
    'siril' = 'siril'
    'gimp' = 'gimp'
  '';
in
{
  home.packages = with pkgs; [ swayest-workstyle ];
  home.activation.sworkstyle_config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p $HOME/.config/sworkstyle; \
      echo "${conf}" > $HOME/.config/sworkstyle/config.toml
  '';
}
