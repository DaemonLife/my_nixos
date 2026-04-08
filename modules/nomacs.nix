{ config, lib, ... }:
let

  nomacs_style = ''
    [General]
    firstTime=false
    windowMaximized=true

    [AppSettings]
    appMode=0
    firstTime.nomacs.3=false
    hideAllPanels=true
    showMenuBar=false
    showRecentFiles=false

    [CustomShortcuts]
    Exit=Q
    Histogram=
    Next%20File=J
    Previous%20File=K
    Thumbnail%20Preview=G
    Thumbnails=Shift+G

    [DisplaySettings]
    showNavigation=false
    stylePlugin=kvantum
    themeName312=System.css
    transition=0

    [DkDialog]
    saveTabsDialog=false
    saveTabsDialog-answer=65536

    [GlobalSettings]
    logRecentFiles=false
    loop=false
    showBgImage=false
    zoomOnWheel=false

    [ResourceSettings]
    cacheMemory=1024
    historyMemory=512

    [SlideShowSettings]
    backgroundColorRGBA=4278190080

    [SynchronizeSettings]
    checkForUpdates=false
    disableUpdateInteraction=false
  '';

in
{

  home.activation.nomacs_style = lib.hm.dag.entryAfter [ "writeBoundary" ] ''

    mkdir -p $HOME/.config/nomacs && cd $HOME/.config/nomacs && echo "${nomacs_style}" > "Image Lounge.conf";

  '';
}
