{ config, ... }:
let
  username = config.home.username;
in
{
  programs.rtorrent = {
    enable = true;
  };
  home.file.".rtorrent.rc".text = ''
    method.insert = cfg.basedir,  private|const|string, (cat,"/home/${username}/Downloads/rtorrent/")
    method.insert = cfg.session,  private|const|string, (cat,(cfg.basedir),".session/")
    method.insert = cfg.download, private|const|string, (cat,(cfg.basedir),"download/")
    method.insert = cfg.watch,    private|const|string, (cat,(cfg.basedir),"watch/")

    ## Create instance directories
    execute.throw = sh, -c, (cat,\
      "mkdir -p \"",(cfg.download),"\" ",\
      "\"",(cfg.watch),"\" ",\
      "\"",(cfg.session),"\" ")

    ## Basic operational settings (no need to change these)
    session.path.set = (cat, (cfg.session))
    directory.default.set = (cat, (cfg.download))
    execute.nothrow = sh, -c, (cat, "echo >",\
      (session.path), "rtorrent.pid", " ",(system.pid))

    # autostart files in watch directory
    schedule2 = watch_directory,5,5,load.start=/home/${username}/Downloads/rtorrent/watch/*.torrent

    # disk space safe
    schedule2 = low_diskspace,5,60,((close_low_diskspace,1024M))

    # if main tracker not works
    dht.mode.set = auto
    dht.override_port.set = 6881
    protocol.pex.set = yes

    port_range = 50000-50000
    port_random = no
    encoding.add = UTF-8
    pieces.hash.on_completion.set = yes
    view.sort_current = seeding, greater=d.ratio=
    ratio.enable=false
    trackers.use_udp.set = yes

    protocol.encryption.set = allow_incoming,try_outgoing,enable_retry
  '';
}
