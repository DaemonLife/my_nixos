{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    eartag # music tag editor
  ];

  programs.cmus = {
    enable = true;

    extraConfig = ''
      ###### COLORS ######
      # [-1..255] or default,

      # black, darkgray, gray, white,
      # red, green, yellow, blue, magenta, cyan,
      # lightred, lightgreen, lightyellow, lightblue, lightmagenta, lightcyan

      # "darkgray" is bold black
      # "gray" is white, "white" is bold white
      # light is just a bold version of color

      # --- MAIN ---

      # centrain bg and separators
      set color_win_bg=black
      set color_separator=black

      # selector
      set color_win_sel_bg=blue
      set color_win_sel_fg=black

      # not played inactive section
      set color_win_inactive_sel_fg=blue
      set color_win_inactive_sel_bg=black

      # focused current play song
      set color_win_cur_sel_fg=black
      set color_win_cur_sel_bg=green

      # unfocused current play song fg
      set color_win_cur=green

      # unfocused current play library
      set color_win_inactive_cur_sel_fg=green
      set color_win_inactive_cur_sel_bg=black

      # album name
      set color_trackwin_album_fg=yellow
      set color_trackwin_album_bg=black

      # --- TOP ---

      set color_win_title_bg=black
      set color_win_title_fg=green

      # --- BOTTOM ---

      # song title
      set color_titleline_fg=black
      set color_titleline_bg=blue

      # progress line
      set color_statusline_progress_fg=black
      set color_statusline_progress_bg=yellow
      set color_statusline_fg=white
      set color_statusline_bg=black

      # cmd
      set color_cmdline_fg=gray
      set color_cmdline_bg=black
      set color_info=yellow
      set color_error=red

      # --- BROWSER (page 5) ---

      set color_win_fg=gray
      set color_win_dir=yellow

      # --- NOTHING? ---

      # set color_win_cur_attr=red
      # set color_cur_sel_attr=red
      # set color_statusline_attr=red
      # set color_win_cur_sel_attr=red
      # set color_win_inactive_sel_attr=red
      # set color_win_sel_attr=red
      # set color_win_attr=red
      # set color_trackwin_album_attr=red
      # set color_titleline_attr=red
      # set color_cmdline_attr=red
      # set color_win_title_attr=red
      # set color_win_inactive_cur_sel_attr=red

      # --- SETUPS ---

      set show_current_bitrate=true
      set shuffle=false
      set continue=true
      set ignore_duplicates=true
      set format_title=%a - %l - %t (%y) - cmus
      set confirm_run=false
      set status_display_program=~/nix/modules/player/cmus_notify.sh
      set progress_bar=color

      # select follow played track, toggle with f key
      set follow=true

      # --- BINDS ---
      # binds. -f means overwrite conflicts.

      bind -f common n player-next
      bind -f common N player-prev
      bind -f common p player-prev
      bind -f common c toggle continue
      bind -f common space player-pause
      bind -f common q quit
      bind -f common t win-toggle

      # edit selected file (or all album files) tags
      bind -f common e run eartag

      # remove selected file
      bind -f common D run sh -c 'file="$1"; dest="${config.home.homeDirectory}/.local/share/Trash/files"; [ -f "$file" ] || exit 0; ${pkgs.cmus}/bin/cmus-remote -C "win-remove" && nohup ${pkgs.coreutils}/bin/mv -- "$file" "$dest"/ >/dev/null 2>&1 &' sh {}

    '';
  };
}
