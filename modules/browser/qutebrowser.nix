{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    python313Packages.adblock
  ];

  programs.qutebrowser = with config.lib.stylix.colors; {
    enable = true;
    # package = pkgs.unstable.qutebrowser;
    loadAutoconfig = true;

    quickmarks = {};

    searchEngines = {
      "!w" = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      "!wt" = "https://ru.wiktionary.org/wiki/{}";
      "!g" = "https://www.google.com/search?hl=en&q={}";
      "!gi" = "https://www.google.com/search?q={}&udm=2";
      "!gt" = "https://translate.google.com/?sl=en&tl=ru&text={}&op=translate";
      "!y" = "https://www.youtube.com/results?search_query={}";
      "!yai" = "https://ya.ru/images/search?from=tabbar&text={}";
      "!nixp" = "https://search.nixos.org/packages?&from=0&size=50&sort=relevance&type=packages&query={}";
      "!nixo" = "https://search.nixos.org/options?size=50&sort=relevance&type=packages&query={}";
      "!nixs" = "https://searchix.ovh/?query={}";
      "!git" = "https://github.com/search?q={}&type=repositories";
      "!gitn" = "https://github.com/search?q={}+language%3Anix&type=code";
      "!wttr" = "https://wttr.in/{}?FMm"; # Weather. Type ":help" for helping
      "!mapo" = "https://www.openstreetmap.org/search?query={}";
      "!mapg" = "https://www.google.com/maps/search/{}";
    };

    aliases = {
      "q" = "close";
      "qa" = "quit";
      "w" = "session-save";
      "wq" = "quit --save";
      "dme" = "set colors.webpage.darkmode.enabled true";
      "dmd" = "set colors.webpage.darkmode.enabled false";
    };

    keyBindings = {
      normal = {
        "<Ctrl+m>" = "hint links spawn --detach proxychains4 -q mpv {hint-url}";
        "<Alt+m>" = "hint links spawn --detach proxychains4 -q vlc {hint-url}";

        # default setup for esc and unfocus all elements (*.blur)
        "<Escape>" = "clear-keychain ;; search ;; fullscreen --leave ;; jseval -q document.activeElement.blur()";
        "<Ctrl+v>" = "nop";
      };
    };

    greasemonkey = [
      # https://github.com/afreakk/greasemonkeyscripts

      (pkgs.writeText "shorts_block_youtube.js" ''
        // ==UserScript==
        // @name         YouTube Shorts Blocker
        // @namespace    http://tampermonkey.net/
        // @version      0.1.2
        // @description  Blocks the YouTube shorts from appearing.
        // @author       Aiden Charles
        // @license      MIT
        // @match        https://www.youtube.com/*
        // @grant        none
        // ==/UserScript==

        (function () {
            setInterval(function () {
                document
                    .querySelectorAll('ytd-reel-shelf-renderer')
                    .forEach((x) => x.remove());
                document
                    .querySelectorAll('ytd-rich-shelf-renderer')
                    .forEach((x) => x.remove());
                document
                    .querySelectorAll("a[title='Shorts']")
                    .forEach((x) => x.remove());
            }, 1000);
        })();
      '')

      (pkgs.writeText "sponsorblock_youtube.js" ''
        // ==UserScript==
        // @name         Sponsorblock
        // @version      1.1.0
        // @description  Skip sponsor segments automatically
        // @author       afreakk
        // @author          vongaisberg
        // @match        *://*.youtube.com/*
        // @exclude      *://*.youtube.com/subscribe_embed?*
        // ==/UserScript==
        const delay = 1000;

        const tryFetchSkipSegments = (videoID) =>

            fetch(`https://sponsor.ajay.app/api/skipSegments?videoID=$\{videoID}`)
                .then((r) => r.json())
                .then((rJson) =>
                    rJson.filter((a) => a.actionType === 'skip').map((a) => a.segment)
                )
                .catch(
                    (e) =>
                        console.log(
                            `Sponsorblock: failed fetching skipSegments for $\{videoID}, reason: $\{e}`
                        ) || []
                );

        const skipSegments = async () => {
            const videoID = new URL(document.location).searchParams.get('v');
            if (!videoID) {
                return;
            }
            const key = `segmentsToSkip-$\{videoID}`;
            window[key] = window[key] || (await tryFetchSkipSegments(videoID));
            for (const v of document.querySelectorAll('video')) {
                if (Number.isNaN(v.duration)) continue;
                for (const [start, end] of window[key]) {
                    if (v.currentTime < end && v.currentTime >= start) {
                        console.log(`Sponsorblock: skipped video @$\{v.currentTime} from $\{start} to $\{end}`);
                        v.currentTime = end;
                        return
                    }
                    const timeToSponsor = (start - v.currentTime) / v.playbackRate;
                    if (v.currentTime < start && timeToSponsor < (delay / 1000)) {
                        console.log(`Sponsorblock: Almost at sponsor segment, sleep for $\{timeToSponsor * 1000}ms`);
                        setTimeout(skipSegments, timeToSponsor * 1000);
                    }
                }
            }
        };
        if (!window.skipSegmentsIntervalID) {
            window.skipSegmentsIntervalID = setInterval(skipSegments, delay);
        }
      '')

      (pkgs.writeText "skip_youtube_ads.js" ''
        // ==UserScript==
        // @name         Auto Skip YouTube Ads
        // @version      1.1.0
        // @description  Speed up and skip YouTube ads automatically
        // @author       jso8910
        // @match        *://*.youtube.com/*
        // @exclude      *://*.youtube.com/subscribe_embed?*
        // ==/UserScript==
        setInterval(() => {
            const btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button')
            if (btn) {
                btn.click()
            }
            const ad = [...document.querySelectorAll('.ad-showing')][0];
            if (ad) {
                const video = document.querySelector('video')
                video.muted = true;
                video.hidden = true;

                // This is not necessarily available right at the start
                if(video.duration != NaN) {
                    video.currentTime = video.duration;
                }

                // 16 seems to be the highest rate that works, mostly this isn't needed
                video.playbackRate = 16;
            }
        }, 50)
      '')
    ];

    settings = {
      auto_save.session = true;

      # spellcheck.languages = [
      #   "en-US"
      # ];

      content = {
        autoplay = false;

        canvas_reading = false;
        javascript.clipboard = "access";
        pdfjs = true;

        blocking = {
          method = "adblock";
          whitelist = [];
          adblock.lists = [
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/refs/heads/master/filters/filters-2025.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"

            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
            "https://easylist.to/easylist/fanboy-social.txt"
            "https://malware-filter.gitlab.io/malware-filter/urlhaus-filter-domains.txt"
            "https://github.com/easylist/easylist/raw/refs/heads/master/easylist_cookie/easylist_cookie_general_block.txt"
            "https://github.com/easylist/easylist/raw/refs/heads/master/easylist_cookie/easylist_cookie_general_hide.txt"
            "https://easylist-downloads.adblockplus.org/advblock.txt"
            "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
            "https://easylist-downloads.adblockplus.org/bitblock.txt"
            "https://easylist-downloads.adblockplus.org/cntblock.txt"
            "https://easylist-downloads.adblockplus.org/easylist.txt"
            "https://raw.githubusercontent.com/easylist/easylist/refs/heads/master/easylist_cookie/easylist_cookie_general_block.txt"
            "https://raw.githubusercontent.com/easylist/easylist/refs/heads/master/easylist_cookie/easylist_cookie_general_hide.txt"
            "https://raw.githubusercontent.com/easylist/easylist/refs/heads/master/easylist_cookie/easylist_cookie_international_specific_hide.txt"
            "https://raw.githubusercontent.com/easylist/easylist/refs/heads/master/easylist_cookie/easylist_cookie_international_specific_block.txt"
          ];
        };
      };

      window = {
        hide_decoration = false; # with true there is error with colors on wayland
        transparent = true;
      };

      scrolling = {
        bar = "always";
        smooth = false;
      };

      tabs = {
        show = "multiple";
        favicons.scale = 0.7;
        favicons.show = "always"; # always, never or pinned
        title.format = "{audio}{current_title}";
        title.format_pinned = "{index}";
        close_mouse_button = "right";
      };

      colors = {
        webpage = {
          preferred_color_scheme = "dark";
          bg = "#${base01}";
          darkmode.enabled = true;
        };
      };

      hints.radius = 0;
      qt.highdpi = true; # f this setting, sometime you need true, sometime false
      zoom = {
        default = "100%";
        text_only = true;
        levels = [
          "25%"
          "33%"
          "50%"
          "67%"
          "75%"
          "90%"
          "100%"
          "110%"
          "120%"
          "130%"
          "140%"
          "150%"
          "175%"
          "190%"
          "200%"
          "225%"
          "250%"
          "300%"
          "350%"
          "400%"
          "500%"
        ];
      };

      # fonts =
      #   let
      #     font_size = config.stylix.fonts.sizes.terminal;
      #   in
      #   {
      #     web.size = lib.mkForce {
      #       default = font_size;
      #       default_fixed = font_size;
      #       minimum = font_size;
      #       minimum_logical = font_size;
      #     };
      #     default_family = lib.mkForce config.stylix.fonts.monospace.name;
      #     web.family.fixed = lib.mkForce config.stylix.fonts.monospace.name;
      #     default_size = lib.mkForce "${toString (font_size)}pt";
      #   };

      fileselect = {
        handler = "external";
        folder.command = ["foot" "-a" "floating_yazi" "-e" "yazi" "--cwd-file" "{}"];
        multiple_files.command = ["foot" "-a" "floating_yazi" "-e" "yazi" "--chooser-file" "{}"];
        single_file.command = ["foot" "-a" "floating_yazi" "-e" "yazi" "--chooser-file" "{}"];
      };

      editor.command = ["foot" "sh" "-c" "vi" "{file}"];

      input = {
        insert_mode.auto_leave = true; # if a non-editable element is clicked.
        insert_mode.leave_on_load = true;
        insert_mode.auto_load = false; # if an editable element is focused after loading the page.
      };
    };

    # --- EXTRA OPTIONS ---
    extraConfig = ''
      c.content.blocking.enabled = True
      # cool setting for fix exit from insert mode - no cursor and active form!
      config.bind('<Escape>', 'mode-leave ;; jseval -q document.activeElement.blur()', mode='insert')

      c.colors.completion.fg = ['#${base03}', '#${base0B}', '#${base08}']

      # Background color of the completion widget for odd rows.
      c.colors.completion.odd.bg = '#${base00}'

      # Background color of the completion widget for even rows.
      c.colors.completion.even.bg = '#${base00}'

      # Foreground color of completion widget category headers.
      c.colors.completion.category.fg = '#${base0B}'

      # Background color of the completion widget category headers.
      c.colors.completion.category.bg = '#${base00}'

      # Top border color of the completion widget category headers.
      c.colors.completion.category.border.top = 'rgba(0,0,0,0)'

      # Bottom border color of the completion widget category headers.
      c.colors.completion.category.border.bottom = 'rgba(0,0,0,0)'

      # Foreground color of the selected completion item.
      c.colors.completion.item.selected.fg = '#${base01}'

      # Background color of the selected completion item.
      c.colors.completion.item.selected.bg = '#${base0D}'

      # Top border color of the selected completion item.
      c.colors.completion.item.selected.border.top = '#${base0D}'

      # Bottom border color of the selected completion item.
      c.colors.completion.item.selected.border.bottom = '#${base0D}'

      # Foreground color of the matched text in the selected completion item.
      c.colors.completion.item.selected.match.fg = '#${base05}'

      # Foreground color of the matched text in the completion.
      c.colors.completion.match.fg = '#${base05}'

      # Color of the scrollbar handle in the completion view.
      c.colors.completion.scrollbar.fg = '#${base0D}'

      # Color of the scrollbar in the completion view.
      c.colors.completion.scrollbar.bg = 'rgba(0,0,0,0)'

      # Background color of the context menu. If set to null, the Qt default
      # is used.
      c.colors.contextmenu.menu.bg = '#${base00}'

      # Foreground color of the context menu. If set to null, the Qt default
      # is used.
      c.colors.contextmenu.menu.fg = '#${base05}'

      # Background color of the context menu's selected item. If set to null,
      # the Qt default is used.
      c.colors.contextmenu.selected.bg = '#${base0D}'

      # Foreground color of the context menu's selected item. If set to null,
      # the Qt default is used.
      c.colors.contextmenu.selected.fg = '#${base02}'

      # Background color of disabled items in the context menu. If set to
      # null, the Qt default is used.
      c.colors.contextmenu.disabled.bg = '#${base00}'

      # Foreground color of disabled items in the context menu. If set to
      # null, the Qt default is used.
      c.colors.contextmenu.disabled.fg = '#${base03}'

      # Background color for the download bar.
      c.colors.downloads.bar.bg = '#${base00}'

      # Color gradient start for download text.
      c.colors.downloads.start.fg = '#${base03}'

      # Color gradient start for download backgrounds.
      c.colors.downloads.start.bg = '#${base0B}'

      # Color gradient end for download text.
      c.colors.downloads.stop.fg = '#${base03}'

      # Color gradient stop for download backgrounds.
      c.colors.downloads.stop.bg = '#${base08}'

      # Foreground color for downloads with errors.
      c.colors.downloads.error.fg = '#${base0F}'

      # Font color for hints.
      c.colors.hints.fg = '#${base01}'

      # Background color for hints. Note that you can use a `rgba(...)` value
      # for transparency.
      c.colors.hints.bg = '#${base08}'

      # Font color for the matched part of hints.
      c.colors.hints.match.fg = '#${base07}'

      # Text color for the keyhint widget.
      c.colors.keyhint.fg = '#${base05}'

      # Highlight color for keys to complete the current keychain.
      c.colors.keyhint.suffix.fg = '#${base03}'

      # Background color of the keyhint widget.
      c.colors.keyhint.bg = '#${base01}'

      # Foreground color of an error message.
      c.colors.messages.error.fg = '#${base01}'

      # Background color of an error message.
      c.colors.messages.error.bg = '#${base0F}'

      # Border color of an error message.
      c.colors.messages.error.border = '#${base0F}'

      # Foreground color of a warning message.
      c.colors.messages.warning.fg = '#${base01}'

      # Background color of a warning message.
      c.colors.messages.warning.bg = '#${base08}'

      # Border color of a warning message.
      c.colors.messages.warning.border = '#${base08}'

      # Foreground color of an info message.
      c.colors.messages.info.fg = '#${base01}'

      # Background color of an info message.
      c.colors.messages.info.bg = '#${base0C}'

      # Border color of an info message.
      c.colors.messages.info.border = '#${base0C}'

      # Foreground color for prompts.
      c.colors.prompts.fg = '#${base05}'

      # Border used around UI elements in prompts.
      c.colors.prompts.border = '0px solid #${base0E}'

      # Background color for prompts.
      c.colors.prompts.bg = '#${base00}'

      # Background color for the selected item in filename prompts.
      c.colors.prompts.selected.bg = '#${base0D}'

      # Foreground color of the statusbar.
      c.colors.statusbar.normal.fg = '#${base03}'

      # Background color of the statusbar.
      c.colors.statusbar.normal.bg = '#${base00}'

      # Foreground color of the statusbar in insert mode.
      c.colors.statusbar.insert.fg = '#${base01}'

      # Background color of the statusbar in insert mode.
      c.colors.statusbar.insert.bg = '#${base0B}'

      # Foreground color of the statusbar in passthrough mode.
      c.colors.statusbar.passthrough.fg = '#${base01}'

      # Background color of the statusbar in passthrough mode.
      c.colors.statusbar.passthrough.bg = '#${base0C}'

      # Foreground color of the statusbar in private browsing mode.
      c.colors.statusbar.private.fg = '#${base01}'

      # Background color of the statusbar in private browsing mode.
      c.colors.statusbar.private.bg = '#${base0F}'

      # Foreground color of the statusbar in command mode.
      c.colors.statusbar.command.fg = '#${base05}'

      # Background color of the statusbar in command mode.
      c.colors.statusbar.command.bg = '#${base00}'

      # Foreground color of the statusbar in private browsing + command mode.
      c.colors.statusbar.command.private.fg = '#${base03}'

      # Background color of the statusbar in private browsing + command mode.
      c.colors.statusbar.command.private.bg = '#${base0F}'

      # Foreground color of the statusbar in caret mode.
      c.colors.statusbar.caret.fg = '#${base00}'

      # Background color of the statusbar in caret mode.
      c.colors.statusbar.caret.bg = '#${base0F}'

      # Foreground color of the statusbar in caret mode with a selection.
      c.colors.statusbar.caret.selection.fg = '#${base00}'

      # Background color of the statusbar in caret mode with a selection.
      c.colors.statusbar.caret.selection.bg = '#${base0F}'

      # Background color of the progress bar.
      c.colors.statusbar.progress.bg = '#${base0B}'

      # Default foreground color of the URL in the statusbar.
      c.colors.statusbar.url.fg = '#${base03}'

      # Foreground color of the URL in the statusbar on error.
      c.colors.statusbar.url.error.fg = '#${base0E}'

      # Foreground color of the URL in the statusbar for hovered links.
      c.colors.statusbar.url.hover.fg = '#${base0F}'

      # Foreground color of the URL in the statusbar on successful load
      # (http).
      c.colors.statusbar.url.success.http.fg = '#${base0C}'

      # Foreground color of the URL in the statusbar on successful load
      # (https).
      c.colors.statusbar.url.success.https.fg = '#${base0B}'

      # Foreground color of the URL in the statusbar when there's a warning.
      c.colors.statusbar.url.warn.fg = '#${base0C}'

      # Background color of the tab bar.
      c.colors.tabs.bar.bg = '#${base00}'

      # Color gradient start for the tab indicator.
      c.colors.tabs.indicator.start = '#${base0B}'

      # Color gradient end for the tab indicator.
      c.colors.tabs.indicator.stop = '#${base0A}'

      # Color for the tab indicator on errors.
      c.colors.tabs.indicator.error = '#${base0F}'

      # Foreground color of unselected odd tabs.
      c.colors.tabs.odd.fg = '#${base05}'

      # Background color of unselected odd tabs.
      c.colors.tabs.odd.bg = '#${base00}'

      # Foreground color of unselected even tabs.
      c.colors.tabs.even.fg = '#${base05}'

      # Background color of unselected even tabs.
      c.colors.tabs.even.bg = '#${base02}'

      # Foreground color of selected odd tabs.
      c.colors.tabs.selected.odd.fg = '#${base00}'

      # Background color of selected odd tabs.
      c.colors.tabs.selected.odd.bg = '#${base0D}'

      # Foreground color of selected even tabs.
      c.colors.tabs.selected.even.fg = '#${base01}'

      # Background color of selected even tabs.
      c.colors.tabs.selected.even.bg = '#${base0D}'

      # Foreground color of pinned unselected odd tabs.
      c.colors.tabs.pinned.odd.fg = '#${base05}'

      # Background color of pinned unselected odd tabs.
      c.colors.tabs.pinned.odd.bg = '#${base00}'

      # Foreground color of pinned unselected even tabs.
      c.colors.tabs.pinned.even.fg = '#${base05}'

      # Background color of pinned unselected even tabs.
      c.colors.tabs.pinned.even.bg = '#${base00}'

      # Foreground color of pinned selected odd tabs.
      c.colors.tabs.pinned.selected.odd.fg = '#${base01}'

      # Background color of pinned selected odd tabs.
      c.colors.tabs.pinned.selected.odd.bg = '#${base0D}'

      # Foreground color of pinned selected even tabs.
      c.colors.tabs.pinned.selected.even.fg = '#${base01}'

      # Background color of pinned selected even tabs.
      c.colors.tabs.pinned.selected.even.bg = '#${base0D}'

      # --- RUS KEYMAP SUPPORT ---
      config.unbind('.')
      en_keys = "qwertyuiop[]asdfghjkl;'zxcvbnm,./"+'QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?'
      ru_keys = 'йцукенгшщзхъфывапролджэячсмитьбю.'+'ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,'
      c.bindings.key_mappings.update(dict(zip(ru_keys, en_keys)))
    '';
  };
}
