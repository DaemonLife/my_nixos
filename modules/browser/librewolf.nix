{
  config,
  lib,
  pkgs,
  ...
}: {
  stylix.targets.librewolf = {
    enable = true;
    profileNames = ["user"];

    # bug with sidebar color bg and popup rounders
    # firefoxGnomeTheme.enable = true;
  };

  programs.librewolf = with config.lib.stylix.colors; {
    enable = true;
    profiles = {"user" = {id = 0;};};
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
      "browser.gesture.swipe.left" = ""; # off
      "browser.gesture.swipe.right" = ""; # off
      # "browser.tabs.firefox-view" = false;
      # "browser.uidensity" = 0; # 0 - normal, 1 - compact, 2 - touch
      # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };

    # profiles.user.extensions.force = true;
    # profiles.user.userChrome = lib.mkForce ''
    #   /* COMMENT ALL
    #
    #   /* ============= Disabled elements =============== */
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
    #   .tab-secondary-label {
    #     display: none !important;
    #   }
    #
    #   /* ====== Sidebar, vertical tabs ======== */
    #
    #   #sidebar-main {
    #     background-color: #${base00} !important;
    #   }
    #
    #   /* no tabs color bg paddings */
    #   #tabbrowser-tabs[orient="vertical"] {
    #     &[expanded] {
    #       & .tab-background {
    #         margin-inline: 0px !important;
    #       }
    #     }
    #   }
    #
    #   /* website icon padding before title */
    #   #tabbrowser-tabs[orient="vertical"] {
    #     &[expanded] {
    #       --tab-icon-end-margin: 32px !important;
    #     }
    #   }
    #
    #   #tabbrowser-tabs[orient="vertical"] {
    #     & .tabbrowser-tab {
    #       &:nth-child(1 of :not([hidden], [pinned])) {
    #         padding-block-start: unset !important;
    #       }
    #     }
    #   }
    #
    #   /* ============ Toolbar ============= */
    #
    #   .browser-toolbar {
    #     color: #${base06};
    #     background-color: #${base00} !important;
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
    #   /* ==================== Tabs ==================== */
    #
    #   /* hide text off */
    #   .tabbrowser-tab {
    #     --tab-label-mask-size: 0em !important;
    #   }
    #
    #   :root {
    #     --tab-min-height: 25px !important;
    #     --tab-block-margin: 0px !important;
    #     --tab-overflow-clip-margin: 0px !important;
    #     --tab-selected-textcolor: #${base00} !important;
    #   }
    #
    #   .tabbrowser-tab .tab-background {
    #     border: none !important;
    #     border-radius: 0px !important;
    #   }
    #
    #   /* selected tab */
    #   .tabbrowser-tab[selected="true"] .tab-background {
    #     background-color: #${base0D} !important;
    #     color: #${base00} !important;
    #   }
    #   .tabbrowser-tab[selected="true"] {
    #     border: 1px !important;
    #     border-color: #${base0E} !important;
    #     color: #${base00} !important;
    #   }
    #
    #   /* not selected tab */
    #   .tabbrowser-tab:not([selected="true"]) .tab-background {
    #     background-color: unset;
    #     color: #${base02} !important;
    #   }
    #
    #   /* hovered tab */
    #   .tabbrowser-tab:hover .tab-background {
    #     filter: brightness(1.15) !important;
    #   }
    #
    #   COMMANT ALL*/
    #
    # '';

    # NEW PAGE STYLE
    profiles.user.userContent = ''
      @-moz-document url("about:home"), url(about:preferences), url("about:blank"), url("about:newtab"), url("about:privatebrowsing") {
        body {
          background-color:#${base00} !important;
          --newtab-search-icon: transparent !important;
        }
      }
    '';
  };
}
