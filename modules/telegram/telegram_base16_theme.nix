{ config, lib, pkgs, ... }:
with config.lib.stylix.colors; let

  telegram_style = ''
    // --- Main UI ---
    windowBg: #${base01}; // RBM menu bg
    windowFg: #${base05};
    windowBgOver: #${base00}; // hover bg in menu and big separator
    windowFgOver: #${base06}; // hover fg in menu
    menuBg: #${base01}; // global bg popup animation after click
    windowFgActive: #${base00}; // fg for some light buttons
    topBarBg: #${base00}; // chat top bg

    // some boxes in ui
    boxBg: windowBg; 
    boxTextFg: windowFg;
    boxTextFgGood: #${base0B};
    boxTextFgError: #${base08};
    boxTitleFg: windowFg;
    boxSearchBg: #${base01};
    boxTitleAdditionalFg: #${base06};
    boxTitleCloseFg: #${base05};
    boxTitleCloseFgOver: #${base06};
    titleFgtitleFgActive: #${base06};

    // media bottom right menu (stupid again)
    mediaviewMenuFg: #${base05}; 
    groupCallMembersFg: #${base05}; 
    groupCallMenuBg: #${base01}; 
    groupCallMenuBgOver: #${base02}; 
    groupCallMenuBgRipple: #${base03}; 

    // up /\ and down \/ arrow for chat and chat list
    historyToDownBg: #${base00};
    historyToDownBgOver: #${base01};
    historyToDownBgRipple: #${base0D};
    historyToDownFg: #${base05};
    historyToDownFgOver: #${base06};
    historyToDownShadow: #00000000;

    // bottom button in chat or channel (mute/unmute/join)
    historyComposeButtonBg: #${base01};
    historyComposeButtonBgOver: #${base02};
    historyComposeButtonBgRipple: #${base0D};

    // activate buttons
    activeButtonBg: #${base01};
    activeButtonBgOver: #${base02};
    activeButtonBgRipple: #${base0D};
    activeButtonFg: #${base05};
    activeButtonFgOver: #${base06};
    activeButtonSecondaryFg: #${base06};
    activeButtonSecondaryFgOver: #${base07};

    // back cancel, close buttons
    cancelIconFg: #${base05};
    cancelIconFgOver: #${base06};
    walletTitleButtonCloseFgActiveOver: #${base08};

    // --- RBM menu ---
    menuSeparatorFg: windowBgOver; // separator
    windowBgRipple: #${base02}; // RBM emoji arrow and some animations bg
    menuBgRipple: #${base01};
    menuIconFg: #${base05};
    menuIconFgOver: #${base06};

    // --- Main settings menu ---
    mainMenuBg: windowBg;
    mainMenuCoverBg: windowBgOver;
    mainMenuCoverFg: windowFgOver;
    checkboxFg: #${base05}; // checkbox and radio buttons
    sliderBgInactive: #${base01}; // slider (notifications and sounds)
    sliderBgActivewindowSubTextFg: #${base06};

    windowSubTextFg: #${base03};
    windowSubTextFgOver: #${base06};
    windowBoldFg: #${base05}; // fg text in some menu
    windowBoldFgOver: #${base06}; // hover fg text in some menu
    windowActiveTextFg: #${base04}; // setap status, description (on, off, ...)

    // --- Notificaton ---
    notificationBg: #${base00};

    // --- Program window title ---
    titleBg: #${base00};

    titleBgActive: titleBg;
    titleButtonBg: titleBg;
    titleButtonFg: #${base05};
    titleButtonBgOver: #${base01};
    titleButtonFgOver: #${base05};
    titleButtonBgActive: titleBgActive;
    titleButtonFgActive: #${base05};
    titleButtonBgActiveOver: titleButtonBgOver;
    titleButtonFgActiveOver: #${base05};
    titleButtonCloseBg: titleBg;
    titleButtonCloseFg: #${base05};
    titleButtonCloseBgOver: #${base08};
    titleButtonCloseFgOver: #${base00};
    titleButtonCloseBgActive: titleBgActive;
    titleButtonCloseFgActive: #${base05};
    titleButtonCloseBgActiveOver: titleButtonCloseBgOver;
    titleButtonCloseFgActiveOverscrollBarBg: #${base05};

    // --- Scroll in CHATS ---
    // bg
    scrollBg: #${base00};
    scrollBgOver: #${base00};
    // fg
    scrollBarBg: #${base03};
    scrollBarBgOver: #${base04};

    // --- Scroll in CHAT ---
    historyScrollBarBgOverhistoryScrollBg: #${base01};
    scrollBgOverhistoryScrollBarBg: #${base05}; 
    scrollBarBgOverscrollBg: #${base05};
    // bg
    historyScrollBg: #${base02};
    historyScrollBgOver: #${base02};
    // fg
    historyScrollBarBg: #${base00};
    historyScrollBarBgOver: #${base04};

    // --- Media player ---
    windowBgActive: #${base0D}; // player progress line fg in chat and (NO WAY!!!...) sliders color, blue default
    mediaviewPlaybackProgressFg: #${base04}; // player progress line bg in chat and FUCK DAMN time clock in full screen video

    // --- Top compact media player ---
    mediaPlayerBg: #${base00};
    mediaPlayerActiveFg: #${base05};
    mediaPlayerInactiveFg: #${base04};
    mediaPlayerDisabledFgradialFg: #${base03};

    // --- Media in full screen ---
    // loading icon
    radialBgmediaviewMenuFg: #${base01};

    mediaviewMenuBgOver: #${base03}; // statick bg of speed line
    mediaviewBg: #${base00};
    mediaviewVideoBg: mediaviewBg;
    mediaviewControlFg: #${base05};

    // caption for photo
    mediaviewCaptionBg: #${base01}aa;
    mediaviewCaptionFg: #${base05};
    mediaviewTextLinkFg: #${base0D};

    // when clicked save button
    mediaviewSaveMsgBg: #${base01};
    mediaviewSaveMsgFg: #${base05};

    // video player
    mediaviewPlaybackActive: #${base05}; // status line fs player
    mediaviewPlaybackInactive: #${base03}; // inactive status line fs player
    mediaviewPlaybackActiveOver: #${base06};
    mediaviewPlaybackInactiveOver: #${base04};
    mediaviewPlaybackIconFg: #${base05};
    mediaviewPlaybackIconFgOver: #${base06};

    // transparent layer (for png)
    mediaviewTransparentBg: #000000ff;
    mediaviewTransparentFg: #${base06};

    // --- Effects ---
    titleShadow: #00000000;
    windowShadowFg: #00000000;
    windowShadowFgFallback: #00000000;
    shadowFg: #${base01}00; // borders color
    slideFadeOutBg: #00000000;
    slideFadeOutShadowFg: #00000000;
    imageBg: #000000ff;
    imageBgTransparent: #000000ff;
    layerBg: #00000050; // Side bar shade

    // input messages in chat
    msgInShadow: #00000000;
    msgInShadowSelected: #00000000;

    // output messages in chat
    msgOutShadow: #00000000;
    msgOutShadowSelected: #00000000;

    // --- Cancel operation button ---
    lightButtonBg: #${base01};
    lightButtonBgOver: #${base02};
    lightButtonBgRipple: #${base01};
    lightButtonFg: #${base05};
    lightButtonFgOver: #${base06};

    // --- Attention (log out button) ---
    attentionButtonFg: #${base05};
    attentionButtonFgOver: #${base00};
    attentionButtonBgOver: #${base08};
    attentionButtonBgRipple: #${base08};

    // --- Close button in notifications? ---
    smallCloseIconFg: #${base05};
    smallCloseIconFgOver: #${base06};

    // --- Message input box ---
    placeholderFg: #${base05}; // 'Wrtie a message...' text (and fg search input... IDIOTS!!!)
    placeholderFgActive: #${base04}; // 'Wrtie a message...' text active (and fg search input active..)

    historyComposeIconFgOverhistoryComposeAreaBg: #${base00};
    historyComposeAreaFg: #${base04}; // pinned msg text and input fg (stupid)
    historyComposeAreaFgService: #${base04}; // pinned media fg
    historySendIconFg: #${base01};
    historySendIconFgOver: #${base01};
    historyPinnedBg: #${base00};
    historyReplyBg: #${base00};
    historyReplyIconFg: #${base01};
    historyReplyCancelFg: #${base01};
    historyReplyCancelFgOver: #${base01};

    // --- Popup when hover message's clock ---
    tooltipBg: #${base01};
    tooltipFg: #${base05};
    tooltipBorderFg: #${base01};

    // --- System tray icon ---
    trayCounterBg: #${base03};
    trayCounterBgMute: #${base01};
    trayCounterFg: #${base05};
    trayCounterBgMacInvert: #${base05};
    trayCounterFgMacInvert: #${base00};

    // --- Contacts menu ---
    contactsBg: #${base00};
    contactsBgOver: windowBgOver;
    contactsNameFg: boxTextFg;
    contactsStatusFg: #${base05};
    contactsStatusFgOver: windowSubTextFgOver;
    contactsStatusFgOnline: #${base05};

    // --- Photo editor ---
    photoCropFadeBg: #000000aa;
    photoCropPointFg: #${base04}7f;

    // --- Login menu? ---
    introBg: #${base00};
    introTitleFg: #${base05};
    introDescriptionFg: #${base05};
    introErrorFg: #${base05};
    introCoverTopBg: #${base00};
    introCoverBottomBg: #${base00};
    introCoverIconsFg: #${base05};
    introCoverPlaneTrace: #${base04};
    introCoverPlaneInner: #${base03};
    introCoverPlaneOuter: #${base04};
    introCoverPlaneTop: #${base03};
    dialogsMenuIconFg: menuIconFg;
    dialogsMenuIconFgOver: menuIconFgOver;

    // --- SMS/PUSH input box? ---
    inputBorderFg: #${base05};

    // --- List of chats, channels and bots ---
    dialogsBg: #${base00};
    dialogsBgActive: #${base0C};
    dialogsNameFg: #${base05};
    dialogsChatIconFg: dialogsNameFg;
    dialogsDateFg: dialogsNameFg;
    dialogsTextFg: dialogsNameFg;
    dialogsTextFgService: dialogsNameFg;
    dialogsDraftFg: dialogsNameFg;
    dialogsVerifiedIconBg: dialogsNameFg;
    dialogsVerifiedIconFg: dialogsBg;
    dialogsSendingIconFg: dialogsNameFg;
    dialogsSentIconFg: dialogsNameFg;

    // chat msg counter icon
    dialogsUnreadBg: #${base0D};

    dialogsTextFgServiceOver: #${base06};
    dialogsNameFgOver: #${base06};
    dialogsChatIconFgOver: #${base06};
    dialogsDateFgOver: #${base06};
    dialogsDraftFgOver: #${base06};
    dialogsVerifiedIconBgOver: dialogsVerifiedIconBg;
    dialogsVerifiedIconFgOver: dialogsVerifiedIconFg;
    dialogsSendingIconFgOver: dialogsSendingIconFg;
    dialogsSentIconFgOver: dialogsSentIconFg;
    dialogsUnreadBgOver: dialogsUnreadBg;
    dialogsUnreadBgMuteddialogsBgOver: #${base03};
    dialogsUnreadBgMutedOverdialogsUnreadFgdialogsTextFgOver: #${base06};
    dialogsUnreadFgdialogsTextFgOver: #${base05};

    dialogsUnreadFgOverdialogsBgActive: #${base02};
    dialogsNameFgActive: #${base00};
    dialogsChatIconFgActive: #${base00};
    dialogsDateFgActive: #${base00};
    dialogsTextFgActive: #${base00};
    dialogsTextFgServiceActive: #${base00};
    dialogsDraftFgActive: #${base00};
    dialogsVerifiedIconBgActive: #${base05};
    dialogsVerifiedIconFgActive: dialogsVerifiedIconFg;
    dialogsSendingIconFgActive: dialogsSendingIconFg;
    dialogsSentIconFgActive: #${base00};
    dialogsUnreadFgActive: #${base01};
    dialogsUnreadBgActive: #${base06};
    dialogsUnreadBgMuted: #${base03};
    dialogsUnreadBgMutedActive: #${base03};
    dialogsForwardBg: #${base02};
    dialogsForwardFg: dialogsNameFgActive;

    // --- Search ---
    filterInputActiveBg: #${base02}; // top search box in chat list
    filterInputInactiveBg: filterInputActiveBg;
    filterInputBorderFg: #${base02}; // ???
    searchedBarBg: #${base00}; // bottom bar bg
    searchedBarFg: #${base04}; // bottom bar fg

    // --- Emoji, stickers, GIFs panel ---
    emojiPanBg: #${base01};
    emojiPanCategories: #${base01};
    emojiPanHeaderFg: #${base05};
    emojiPanHeaderBg: #${base01}; // it does not works...
    emojiIconFg: #${base05}; // emoji category fg
    stickerPreviewBg: #2020207f; // full screen bg
    stickerPanDeleteBg: #${base01}; // delete icon for sticker
    stickerPanDeleteFg: #${base05};

    // --- In chat ---

    reportSpamFg: #${base05};

    // Media in msg wheh msg selected
    msgSelectOverlay: #${base02}7f;
    msgStickerOverlay: #${base02}7f;

    // sound icon in msg media
    historyFileThumbIconFg: #${base05};
    historyFileThumbIconFgSelected: #${base0D};

    // media download animation in msg
    historyFileThumbRadialFg: historyFileThumbIconFg;
    historyFileThumbRadialFgSelected: historyFileThumbIconFgSelected;

    // servis msg is msg of chat itself
    msgServiceFg: #${base06};
    msgServiceBg: #${base01};
    msgServiceBgSelected: #${base0D};

    // date on image in msg
    msgDateImgFg: #${base05};
    msgDateImgBg: #${base00}7f;
    msgDateImgBgOver: msgDateImgBg;
    msgDateImgBgSelected: #${base01};

    // bot buttons
    msgBotKbOverBgAdd: msgServiceBg;
    msgBotKbIconFg: msgServiceFg;
    msgBotKbRippleBg: menuBgRipple;

    // --- Input message in chat ---
    historyTextInFg: #${base05};
    historyCaptionInFg: historyTextInFg;
    historyFileNameInFg: historyTextInFg;
    historySendingInIconFg: historyTextInFg;
    msgInBg: #${base00};
    msgInServiceFg: historyTextInFg;
    msgInDateFg: historyTextInFg;
    msgInMonoFg: historyTextInFg;
    msgInReplyBarColor: historyTextInFg;

    historyFileInIconFg: msgInBg;
    historyFileInRadialFg: msgInBg;
    msgFileThumbLinkInFg: lightButtonFg;
    msgFileInBg: #${base05};
    msgFile4BgSelectedyoutubePlayIconBg: #${base06};

    msgWaveformInInactive: #${base02};
    mediaInFg: msgInDateFg;
    historyLinkInFg: #${base0E};

    // selected
    historyTextInFgSelected: #${base00};
    msgInBgSelected: #${base0D};
    msgInServiceFgSelected: #${base0D};
    msgInDateFgSelected: #${base00};
    historyFileInIconFgSelected: #${base0D};
    historyFileInRadialFgSelected: historyFileInIconFgSelected;
    msgFileThumbLinkInFgSelected: #${base05};
    msgFileInBgSelected: windowBoldFg;
    msgWaveformInActiveSelected: #${base06};
    msgWaveformInInactiveSelected: #${base01};
    mediaInFgSelected: #${base06};

    // --- Output message in chat (from me) ---
    historyTextOutFg: #${base00};
    historyCaptionOutFg: historyTextOutFg;
    historyFileNameOutFg: historyTextOutFg;
    historyOutIconFg: historyTextOutFg;
    msgOutBg: #${base05};
    msgOutDateFg: historyTextOutFg;
    msgOutServiceFg: historyTextOutFg;
    msgOutMonoFg: historyTextOutFg;
    msgOutReplyBarColorhistoryFileOutIconFg: #${base00};
    msgOutBgSelectedhistoryPeerUserpicFg: #${base00}; 

    historyFileOutRadialFg: msgOutBg;
    msgFileThumbLinkOutFg: #${base0D}; // 'OPEN WITH' file text
    msgFileOutBg: #${base00};
    msgFileInBgOvermsgWaveformInActive: #${base01};

    msgFileOutBgOvermsgWaveformOutActive: #${base0D};
    msgWaveformOutInactivemediaOutFg: #${base0D};

    historyLinkOutFg: #${base0E};

    // selected like in
    historyTextOutFgSelected: historyTextInFgSelected;
    historyOutIconFgSelected: historyTextInFgSelected;
    msgOutReplyBarSelColor: #${base05};
    historySendingOutIconFg: historyTextInFgSelected;
    msgFileThumbLinkOutFgSelected: historyTextInFgSelected;
    msgFileOutBgSelected: msgFileInBgSelected;
    msgWaveformOutActiveSelected: msgWaveformInActiveSelected;
    msgWaveformOutInactiveSelected: msgWaveformInInactiveSelected;
    mediaOutFgSelected: mediaInFgSelected;
    historyFileOutIconFgSelected: historyFileInIconFgSelected;
    historyFileOutRadialFgSelected: historyFilenInRadialFgSelected;
    msgOutServiceFgSelected: msgInServiceFgSelected;
    msgOutDateFgSelected: msgInDateFgSelected;
    msgInReplyBarSelColorhistoryFileInIconFg: #${base00};


    // --- User withoin avatar ---
    historyPeer1NameFg: #${base08}; // red
    historyPeer1UserpicBg: #${base08};
    historyPeer2NameFg: #${base0B}; // green
    historyPeer2UserpicBg: #${base0B};
    historyPeer3NameFg: #${base0A}; // yellow
    historyPeer3UserpicBg: #${base0A};
    historyPeer4NameFg: #${base0C}; // blue
    historyPeer4UserpicBg: #${base0C};
    historyPeer5NameFg: #${base0E}; // purple
    historyPeer5UserpicBg: #${base0E};
    historyPeer6NameFg: #${base0F}; // pink
    historyPeer6UserpicBg: #${base0F};
    historyPeer7NameFg: #${base0D}; // sea
    historyPeer7UserpicBg: #${base0D};
    historyPeer8NameFg: #${base09}; // orange
    historyPeer8UserpicBg: #${base09};

    // --- Files/links ---
    msgFile1Bg: #${base01}; // blue
    msgFile1BgDark: #${base0D};
    msgFile1BgOver: #${base04};
    msgFile1BgSelected: #${base04};
    msgFile2Bg: #${base01}; // green
    msgFile2BgDark: #${base0B};
    msgFile2BgOver: #${base04};
    msgFile2BgSelected: #${base04};
    msgFile3Bg: #${base01}; // red
    msgFile3BgDark: #${base08};
    msgFile3BgOver: #${base04};
    msgFile3BgSelected: #${base04};
    msgFile4Bg: #${base01}; // yellow
    msgFile4BgDark: #${base0A};
    msgFile4BgOver: #${base04};

    youtubePlayIconFg: #${base08};
    videoPlayIconBg: #${base00}80; // other video services
    topBarBgreportSpamBg: #${base00};

    toastFg: #${base05};

    // --- Side bar ---
    sideBarBg: #${base00};
    sideBarBgActive: #${base00};
    sideBarIconFg: #${base04};
    sideBarIconFgActive: #${base0C};
    sideBarBadgeBg: sideBarIconFgActive;
    sideBarBadgeBgMuted: sideBarIconFg; // not active or muted badge
    sideBarBadgeFg: sideBarBg; // text in badge
    sideBarBgRipple: #${base08}; // bg animation when icon clicked

    // both work like active lol
    sideBarTextFgActive: sideBarIconFgActive;
    sideBarTextFg: sideBarIconFg;

    // --- ??? ---
    activeLineFg: #${base05};
    activeLineFgError: #${base05};
    outlineButtonBg: #${base00};
    outlineButtonBgOver: lightButtonBgOver;
    outlineButtonOutlineFg: windowBgActive;
    outlineButtonBgRipple: lightButtonBgRipple;
    menuSubmenuArrowFg: #${base03};
    menuFgDisabled: #${base03};
    membersAboutLimitFg: windowSubTextFgOver;
    historyIconFgInverted: #${base05};
    historySendingInvertedIconFg: #${base05};
    historyUnreadBarBg: #${base00};
    historyUnreadBarBorder: shadowFg;
    historyUnreadBarFg: #${base05};
    historyForwardChooseBg: #${base01};
    historyForwardChooseFg: #${base05};
    msgImgReplyBarColor: #${base05};
    overviewCheckBg: #${base01};
    overviewCheckFg: #${base04};
    overviewCheckFgActive: #${base01};
    overviewPhotoSelectOverlay: #${base02};
    profileStatusFgOver: #${base04};
    profileVerifiedCheckBg: #${base05};
    profileVerifiedCheckFg: #${base01};
    profileAdminStartFg: #${base05};
    notificationsBoxMonitorFg: #${base05};
    notificationsBoxScreenBg: #${base05};
    notificationSampleUserpicFg: #${base01};
    notificationSampleCloseFg: #${base05};
    notificationSampleTextFg: #${base05};
    notificationSampleNameFg: #${base04};
    mediaviewFileBg: #000000;
    mediaviewFileNameFg: #${base05};
    mediaviewFileSizeFg: #${base05};
    mediaviewFileRedCornerFg: #${base08};
    mediaviewFileYellowCornerFg: #${base0A};
    mediaviewFileGreenCornerFg: #${base0B};
    mediaviewFileBlueCornerFg: #${base0D};
    mediaviewFileExtFg: activeButtonFg;
    mediaviewMenuBg: #${base01};
    mediaviewMenuBgRipple: menuBgRipple;
    mediaviewControlBg: #${base05};
    mainMenuCloudBg: #${base03};
    overviewCheckBorder: #${base08};
    dialogsOnlineBadgeFgActive: #${base08};
    menuBgOver: #${base02};

  '';
in
{

  home.activation.telegram_style = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # create theme
    cd $HOME/.config && echo "${telegram_style}" > tmp_colors.tdesktop-theme;
    sed '/^#/d' tmp_colors.tdesktop-theme > colors.tdesktop-theme;
    ${pkgs.imagemagick}/bin/magick -size 512x512 xc:#${base02} -depth 8 -colorspace sRGB -quality 100 tiled.jpg;
    ${pkgs.zip}/bin/zip telegram-base16.zip tiled.jpg colors.tdesktop-theme;
    mv telegram-base16.zip telegram-base16.tdesktop-theme;
    rm -rf colors.tdesktop-theme tmp_colors.tdesktop-theme tiled.jpg;
  '';
}
