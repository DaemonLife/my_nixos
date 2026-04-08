{ config, lib, pkgs, ... }: {
  stylix.targets.firefox = {
    enable = true;
    profileNames = [ "user" ];
    firefoxGnomeTheme.enable = false;
  };

  home.packages = with pkgs; [ ];

  programs.firefox = with config.lib.stylix.colors; {
    enable = true;
    languagePacks = [ "en-US" "ru" ];
    policies = {
      # BlockAboutConfig = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
    };

    profiles.user.settings = {
      "identity.fxaccounts.enabled" = true; # firefox sync
      "privacy.clearOnShutdown.history" = true;
      "privacy.clearOnShutdown.downloads" = true;
      "middlemouse.paste" = false;
      "general.autoScroll" = false;
      "general.smoothScroll" = true;
      "sidebar.revamp" = false;
      "sidebar.verticalTabs" = false;
      # "sidebar.main.tools" = "history";
      # "browser.uidensity" = 1; # 0 - normal, 1 - compact, 2 - touch
      "browser.compactmode.show" = true;
      "browser.gesture.swipe.left" = "";
      "browser.gesture.swipe.right" = "";
      "browser.tabs.firefox-view" = false;
      # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # disable AI
      "browser.ai.control.default" = "blocked";

      # search
      "browser.urlbar.showSearchTerms.enabled" = false; # bc annoying bug

      # secure
      "browser.contentblocking.category" = "strict";
      "browser.uitour.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = true;
      "privacy.userContext.enabled" = true;
      "privacy.userContext.ui.enabled" = true;
      "dom.security.https_only_mode" = true; # https only?

      # disable telemetry
      "datareporting.policy.dataSubmissionEnabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.usage.uploadEnabled" = false;

      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.tabs.crashReporting.sendReport" = false;
      "breakpad.reportURL" = "";

      # ui change
      "browser.discovery.enabled" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "browser.profiles.enabled" = false;
      "browser.urlbar.trending.featureGate" = false;
      "browser.newtabpage.activity-stream.default.sites" = "";
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
      "ui.systemUsesDarkTheme" = 1;
    };

    # profiles.user.extensions.force = true;
    # profiles.user.userChrome = lib.mkForce ''
    #   /*
    #   ========================================
    #     DISABLED ELEMENTS
    #   ========================================
    #   */
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
    #   #new-tab-button, .tab-secondary-label {
    #     display: none !important;
    #   }
    #
    #   /*
    #   ========================================
    #   📏 SIZE & SPACING
    #   ========================================
    #   */
    #
    #   .bookmark-item > .toolbarbutton-icon {
    #     width: ${toString config.stylix.fonts.sizes.applications}px !important;
    #     height: ${toString config.stylix.fonts.sizes.applications}px !important;
    #   }
    #
    #   /*
    #   ========================================
    #     COLORS & FORMS
    #   ========================================
    #   */
    #
    #   #sidebar-main {
    #     background-color: #${base00} !important;
    #   }
    #
    #   .tabbrowser-tab .tab-background {
    #     border: none !important;
    #     border-radius: 8px !important;
    #     background-color: #${base01} !important;
    #   }
    #
    #   .tabbrowser-tab {
    #     margin: 0px !important;
    #     padding: 4px 0px 0px 0px !important;
    #   }
    #
    #   /* Активная вкладка */
    #   .tabbrowser-tab[selected="true"] .tab-background {
    #     background-color: #${base0D} !important;
    #   }
    #
    #   .tabbrowser-tab[selected="true"] {
    #     border: 0px !important;
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
    #   /* No white flash on new tab opening in dark theme */
    #   #browser vbox#appcontent tabbrowser, #content, #tabbrowser-tabpanels, browser[type=content-primary], browser[type=content] > html { background: #${base00} !important; }
    #
    # '';
    # profiles.user.userChrome = lib.mkForce ''
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
    # '';

    # NEW PAGE SETAP
    profiles.user.userContent = ''
      @-moz-document url("about:home"),url(about:preferences),url("about:blank"),url("about:newtab"),url("about:privatebrowsing"){
          body{background-color:#${base00}!important;--newtab-search-icon: transparent !important;}
      }

      /* dark blank tab */
      u/-moz-document url(about:blank), url(about:newtab) {
        #newtab-window, html:not(#ublock0-epicker) {
          background: #${base00} !important;
        }
      }
    '';
  };
}
