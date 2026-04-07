{ config, lib, ... }: {
  stylix.targets.librewolf = {
    enable = true;
    profileNames = [ "user" ];
    # firefoxGnomeTheme.enable = true;
  };

  programs.librewolf = with config.lib.stylix.colors; {
    enable = true;
    profiles = {
      "user" = { id = 0; };
    };
    settings = {
      "identity.fxaccounts.enabled" = true; # firefox sync
      "privacy.clearOnShutdown.history" = true;
      "privacy.clearOnShutdown.downloads" = true;
      "middlemouse.paste" = false;
      "general.autoScroll" = false;
      "general.smoothScroll" = true;
      # "sidebar.revamp" = true;
      # "sidebar.verticalTabs" = true;
      # "sidebar.main.tools" = "history";
      "browser.gesture.swipe.left" = "";
      "browser.gesture.swipe.right" = "";
      "browser.tabs.firefox-view" = false;
      # "browser.uidensity" = 0; # 0 - normal, 1 - compact, 2 - touch
      # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };

    # profiles.user.extensions.force = true;
    # profiles.user.userChrome = lib.mkForce ''
    #
    #   /* ============== Disable elements =============== */
    #
    #   /*
    #   #context_reopenInContainer,
    #   #tracking-protection-icon-container,
    #   #pageActionButton,
    #   #pageActionSeparator,
    #   */
    #
    #   #image.autoplay-media-icon,
    #   #context_moveTabOptions,
    #   #context_sendTabToDevice,
    #   #context_selectAllTabs,
    #   #context_closeTabOptions,
    #   #wrapper-firefox-view-button,
    #   #fxa-toolbar-menu-button,
    #   #reader-mode-button,
    #   #new-tab-button,
    #   .tab-secondary-label{
    #     display: none !important;
    #   }
    #
    #   /* ==================== Sidebar ==================== */
    #
    #   #sidebar-main {
    #     background-color: #${base00} !important;
    #   }
    #
    #   /* ==================== Tabs ==================== */
    #
    #   .tabbrowser-tab .tab-background {
    #     border: none !important;
    #     border-radius: 0px !important;
    #   }
    #
    #   /* Активная вкладка */
    #   .tabbrowser-tab[selected="true"] .tab-background {
    #     background-color: #${base0D} !important;
    #   }
    #
    #   .tabbrowser-tab[selected="true"] {
    #     border: 1px !important;
    #     border-color: #${base0E} !important;
    #     color: #${base00} !important;
    #   }
    #
    #   /* Неактивные вкладки */
    #   .tabbrowser-tab:not([selected="true"]) .tab-background {
    #     background-color: #${base01} !important;
    #     color: #${base03} !important;
    #   }
    #
    #   /* Подсвет при наведении */
    #   .tabbrowser-tab:hover .tab-background {
    #     filter: brightness(1.15) !important;
    #   }
    #
    #   /* Кнопки навигации – слегка приглушить */
    #   #nav-bar toolbarbutton {
    #     color: #${base04} !important;
    #     fill: #${base04} !important;
    #   }
    #   #nav-bar toolbarbutton:hover {
    #     color: #${base06} !important;
    #     fill: #${base06} !important;
    #   }
    #
    #
    #
    #
    #
    # '';
    #
    # # NEW PAGE SETAP
    # profiles.user.userContent =
    #   # css
    #   ''
    #     @-moz-document url("about:home"),url(about:preferences),url("about:blank"),url("about:newtab"),url("about:privatebrowsing"){
    #         body{background-color:#${base00}!important;--newtab-search-icon: transparent !important;}
    #     }
    #   '';
  };
}
