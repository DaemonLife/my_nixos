{ ... }: {
  programs.cmus = {
    enable = true;

    extraConfig = ''
      # --- COLORS ---
      # set color_cmdline_attr=default # doint nothing
      set color_cmdline_bg=black
      set color_cmdline_fg=gray

      # set color_cur_sel_attr=default
      set color_error=lightred
      set color_info=lightyellow
      set color_separator=gray

      # set color_statusline_attr=default # also
      set color_statusline_bg=black
      set color_statusline_fg=gray

      # set color_titleline_attr=default
      set color_titleline_bg=lightgreen
      set color_titleline_fg=black

      # album name
      # set color_trackwin_album_attr=default
      set color_trackwin_album_bg=black
      set color_trackwin_album_fg=yellow

      # set color_win_attr=default
      set color_win_bg=black
      set color_win_cur=lightgreen

      # set color_win_cur_attr=default
      # set color_win_cur_sel_attr=default
      set color_win_cur_sel_bg=lightgreen
      set color_win_cur_sel_fg=black
      set color_win_dir=yellow
      set color_win_fg=gray

      # set color_win_inactive_cur_sel_attr=default
      set color_win_inactive_cur_sel_bg=default
      set color_win_inactive_cur_sel_fg=white

      # set color_win_inactive_sel_attr=default
      set color_win_inactive_sel_bg=gray
      set color_win_inactive_sel_fg=black

      # set color_win_sel_attr=default
      set color_win_sel_bg=blue
      set color_win_sel_fg=black

      # set color_win_title_attr=default
      set color_win_title_bg=black
      set color_win_title_fg=lightgreen
      # --- COLORS ---

      set show_current_bitrate=true
      set shuffle=tracks
      set continue=true
      set ignore_duplicates=true

      # binds. -f means overwrite conflicts.
      bind -f common n player-next
      bind -f common N player-prev
      bind -f common p player-prev
      bind -f common c toggle continue
      bind -f common space player-pause
      bind -f common q quit
    '';
  };
}
