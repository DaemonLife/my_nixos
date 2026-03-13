{ config, pkgs, ... }:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [ nchat ];

  # user names fg colors
  home.file.".config/nchat/usercolor.conf".text = ''
    0x${base08-hex}
    0x${base0B-hex}
    0x${base0A-hex}
    0x${base0C-hex}
    0x${base0E-hex}
    0x${base0F-hex}
    0x${base0D-hex}
    0x${base09-hex}
  '';

  home.file.".config/nchat/color.conf".text = ''
    default_color_bg=
    default_color_fg=
    dialog_attr=
    dialog_attr_selected=reverse
    dialog_color_bg=
    dialog_color_fg=
    dialog_shaded_color_bg=
    dialog_shaded_color_fg=blue
    entry_attr=
    entry_color_bg=
    entry_color_fg=white
    help_attr=reverse
    help_color_bg=black
    help_color_fg=white
    history_name_attr=bold
    history_name_attr_selected=reverse
    history_name_recv_color_bg=
    history_name_recv_color_fg=
    history_name_recv_group_color_bg=
    history_name_recv_group_color_fg=usercolor
    history_name_sent_color_bg=
    history_name_sent_color_fg=blue
    history_text_attachment_color_bg=
    history_text_attachment_color_fg=0x${base04-hex}
    history_text_attr=
    history_text_attr_selected=reverse
    history_text_quoted_color_bg=
    history_text_quoted_color_fg=gray
    history_text_reaction_color_bg=
    history_text_reaction_color_fg=gray
    history_text_recv_color_bg=
    history_text_recv_color_fg=
    history_text_recv_group_color_bg=
    history_text_recv_group_color_fg=
    history_text_sent_color_bg=
    history_text_sent_color_fg=blue
    list_attr=
    list_attr_selected=reverse
    list_color_bg=
    list_color_fg=
    listborder_attr=
    listborder_color_bg=
    listborder_color_fg=
    status_attr=reverse
    status_color_bg=
    status_color_fg=
    top_attr=reverse
    top_color_bg=
    top_color_fg=
  '';

  home.file.".config/nchat/ui.conf".text = ''
    attachment_indicator=📎
    attachment_open_command=xdg-open >/dev/null 2>&1 '%1' &
    away_status_indication=0
    call_command=
    chat_picker_sorted_alphabetically=0
    confirm_deletion=1
    desktop_notify_active=0
    desktop_notify_command=notify-send -a nchat '%1' '%2' -t 2000
    desktop_notify_inactive=0
    downloadable_indicator=+
    emoji_enabled=1
    entry_height=1
    failed_indicator=✗
    file_picker_command=yazi --chooser-file='%1'
    file_picker_persist_dir=1
    help_enabled=0
    home_fetch_all=0
    linefeed_on_enter=1
    link_open_command=
    list_enabled=1
    list_width=18
    listdialog_show_filter=1
    mark_read_on_view=1
    mark_read_when_inactive=0
    message_edit_command=
    message_open_command=
    muted_indicate_unread=1
    muted_notify_unread=0
    muted_position_by_timestamp=1
    online_status_dynamic=1
    online_status_share=1
    phone_number_indicator=
    proxy_indicator=🔒
    reactions_enabled=1
    read_indicator=✓
    spell_check_command=
    status_broadcast=1
    syncing_indicator=⇄
    terminal_bell_active=0
    terminal_bell_inactive=1
    terminal_title=Telegram tui
    top_enabled=0
    top_show_version=0
    transfer_send_caption=1
    typing_status_share=1
    unread_indicator=*
  '';
}
