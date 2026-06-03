{
  config,
  pkgs,
  ...
}: {
  programs.mpv = with config.lib.stylix.colors; {
    enable = true;

    bindings = {
      r = "cycle_values video-rotate 90 180 270 0";
      "Alt+s" = "cycle sub";
      "Alt+S" = "cycle sub down";
      "Alt+a" = "cycle audio";
      "Alt+A" = "cycle audio down";
      "Alt+m" = "script-binding select/menu";
    };

    scripts = with pkgs; [
      # mpvScripts.sponsorblock
      # mpvScripts.dynamic-crop # press 'C'
      # mpvScripts.crop # press 'C'
      mpvScripts.mpris # for using standard media keys
      mpvScripts.autosubsync-mpv # press 'n' to sync subtitles
    ];

    config = {
      # ui settings
      osc = true; # false for disable default ui
      osd-bar = true; # false for disable default ui
      # border = false;
      fullscreen = "no";
      # osd-font = "";
      osd-font-size = 30;
      keep-open = "no";
      volume = 80;
      volume-max = 100;
      # sub-font = "Cantarell Regular";
      sub-bold = "yes";
      sub-font-size = 46;
      sub-border-size = 3;
      sub-auto = "fuzzy"; # subs that do not match file name perfectly.

      # lang
      slang = "ru,rus,en,eng,us"; # subtitle
      vlang = "en,eng,us,fr,de"; # video
      alang = "en,eng,us,fr,de"; # audio
      # youtube support
      ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
      # performance and quality
      hwdec = "auto";
      cache = "yes";
      # cache-default = 4000000;
      demuxer-readahead-secs = 20;
      demuxer-max-bytes = "2048MiB";
      demuxer-max-back-bytes = "2048MiB";
      # interpolation = true;
      # video-sync = "display-resample";

      # other
      save-position-on-quit = true;

      # Screenshot
      screenshot-format = "png";
      screenshot-template = "%F-%P";
      screenshot-sw = "no"; # use software rendering
      screenshot-png-compression = 7; # range 0-9, higher values may lag
      screenshot-high-bit-depth = "yes";
      screenshot-directory = "~/Pictures/mpv-screenshots";
    }; # end of config

    scriptOpts = {
      thumbfast = {
        spawn_first = true;
        network = true;
        hwdec = true;
      };
    };
  };

  # other script
  home.file.".config/mpv/scripts/mpv-sub_not_forced_not_sdh.lua".text = ''
    function select_not_forced_subtitle()
        local preferred_sub = nil
        print("--- Running select_not_forced_subtitle script ---")

        for i, sub in ipairs(mp.get_property_native("track-list")) do
            if sub.type == "sub" and (sub.lang:find("rus") or sub.lang:find("ru")) then
                print(string.format("Found Russian subtitle: ID=%s, Title='%s', Forced=%s, Default=%s",
                                    sub.id, sub.title or "nil", tostring(sub.forced), tostring(sub.default)))

                -- Check if it's explicitly marked as forced by mpv
                if sub.forced then
                    print("Skipping: Subtitle is marked as 'forced'.")
                    goto continue_loop
                end

                -- Check common forced indicators in title (case-insensitive)
                local title_lower = string.lower(sub.title or "")
                if title_lower:find("forced") or title_lower:find("force") then
                    print("Skipping: Title contains 'forced' or 'force'.")
                    goto continue_loop
                end

                -- Check for SDH (often not desired for forced subtitles)
                if title_lower:find("sdh") then
                    print("Skipping: Title contains 'SDH'.")
                    goto continue_loop
                end

                -- If we reach here, this subtitle seems to be a good candidate
                -- We want to find *any* non-forced, non-SDH, non-"force" Russian subtitle.
                -- The first one we find will be preferred, or you can refine this to pick the "best" one.
                preferred_sub = sub
                print("Found a suitable non-forced Russian subtitle candidate.")
                break -- Found a suitable one, no need to check further

                ::continue_loop::
            end
        end

        if preferred_sub then
            mp.set_property("sid", preferred_sub.id)
            print(string.format("Selected subtitle ID: %s (Title: '%s')", preferred_sub.id, preferred_sub.title or "nil"))
        else
            mp.set_property("sid", "no") -- Ensure no subtitle is selected if no suitable one is found
            print("No suitable non-forced Russian subtitle found. No subtitle selected.")
        end
        print("--- Script finished ---")
    end

    mp.register_event("file-loaded", select_not_forced_subtitle)
  '';
}
