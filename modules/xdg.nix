{ ... }: {
  xdg.mime = {
    enable = true;
  };

  xdg.mimeApps = {

    defaultApplications = {
      "text/html" = [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
      # "x-scheme-handler/nxm" = "vortex-downloads-handler.desktop";
      # "x-scheme-handler/nxm-protocol" = "vortex-downloads-handler.desktop";
      "video/mp2t" = "mpv.desktop";
      "video/vnd.avi" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/vnd.mpegurl" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/dv" = "mpv.desktop";
      "video/x-flic" = "mpv.desktop";
      "video/vnd.rn-realvideo" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/3gpp2" = "mpv.desktop";
      "image/jpeg" = "nomacs.desktop";
    };
  };

}
