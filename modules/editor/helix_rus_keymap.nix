{ ... }: {
  programs.helix.settings = {
    keys = {

      # #################
      # NORMAL MODE
      # #################

      normal = {
        "р" = "move_char_left"; # h
        "о" = "move_visual_line_down"; # j
        "л" = "move_visual_line_up"; # k
        "д" = "move_char_right"; # l
        "ц" = "move_next_word_start"; # w
        "и" = "move_prev_word_start"; # b
        "у" = "move_next_word_end"; # e
        "Ц" = "move_next_long_word_start"; # W
        "И" = "move_prev_long_word_start"; # B
        "У" = "move_next_long_word_end"; # E

        "е" = "find_till_char"; # t
        "а" = "find_next_char"; # f
        "Е" = "till_prev_char"; # T
        "А" = "find_prev_char"; # F
        "П" = "goto_line"; # G

        "home" = "goto_line_start";
        "end" = "goto_line_end";
        "A-ю" = "repeat_last_motion"; # Alt-.

        "C-и" = "page_up"; # Ctrl-b, PageUp
        "C-а" = "page_down"; # Ctrl-f, PageDown
        "C-г" = "page_cursor_half_up"; # Ctrl-u
        "C-в" = "page_cursor_half_down"; # Ctrl-d
        "C-ш" = "jump_forward"; # Ctrl-i (tab)
        "C-о" = "jump_backward"; # Ctrl-o
        "C-ы" = "save_selection"; # Ctrl-s

        # --- Изменения ---
        "к" = "replace"; # r
        "К" = "replace_with_yanked"; # R
        "Ё" = "switch_case"; # ~
        "ё" = "switch_to_lowercase"; # `
        "A-ё" = "switch_to_uppercase"; # Alt-`
        "ш" = "insert_mode"; # i
        "ф" = "append_mode"; # a
        "Ш" = "insert_at_line_start"; # I
        "Ф" = "insert_at_line_end"; # A
        "щ" = "open_below"; # o
        "Щ" = "open_above"; # O
        "г" = "undo"; # u
        "Г" = "redo"; # U
        "A-г" = "earlier"; # Alt-u
        "A-Г" = "later"; # Alt-U
        "н" = "yank"; # y
        "з" = "paste_after"; # p
        "З" = "paste_before"; # P
        "Ю" = "indent"; # >
        "Б" = "unindent"; # <
        "в" = "delete_selection"; # d
        "A-в" = "delete_selection_noyank"; # Alt-d
        "с" = "change_selection"; # c
        "A-с" = "change_selection_noyank"; # Alt-c
        "C-ф" = "increment"; # Ctrl-a
        "C-ч" = "decrement"; # Ctrl-x
        "Й" = "record_macro"; # Q
        "й" = "replay_macro"; # q
        "=" = "format_selections";
        "C-я" = "suspend"; # C-z

        # --- Выделение ---
        "м" = "select_mode"; # v
        "ы" = "select_regex"; # s
        "Ы" = "split_selection"; # S
        "A-ы" = "split_selection_on_newline"; # Alt-s
        "ж" = "collapse_selection"; # ;
        "A-ж" = "flip_selections"; # Alt-;
        "A-Ж" = "ensure_selections_forward"; # Alt-: (Shift+Alt+;)
        "б" = "keep_primary_selection"; # ,
        "A-б" = "remove_primary_selection"; # Alt-,
        "С" = "copy_selection_on_next_line"; # C
        "A-С" = "copy_selection_on_prev_line"; # Alt-C
        "ч" = "extend_line_below"; # x
        "Ч" = "extend_to_line_bounds"; # X
        "A-ч" = "shrink_to_line_bounds"; # Alt-x
        "О" = "join_selections"; # J
        "A-О" = "join_selections_space"; # Alt-J
        "Л" = "keep_selections"; # K
        "A-Л" = "remove_selections"; # Alt-K
        "C-с" = "toggle_comments"; # Ctrl-c
        "A-щ" = "expand_selection"; # Alt-o
        "A-ш" = "shrink_selection"; # Alt-i
        "A-з" = "select_prev_sibling"; # Alt-p
        "A-т" = "select_next_sibling"; # Alt-n
        "A-ф" = "select_all_siblings"; # Alt-a
        "A-Ш" = "select_all_children"; # Alt-I
        "A-у" = "move_parent_node_end"; # Alt-e
        "A-и" = "move_parent_node_start"; # Alt-b
        "%" = "select_all";
        "_" = "trim_selections";
        "A-minus" = "merge_selections";
        "A-_" = "merge_consecutive_selections";
        "(" = "rotate_selections_backward";
        ")" = "rotate_selections_forward";
        "A-(" = "rotate_selection_contents_backward";
        "A-)" = "rotate_selection_contents_forward";

        # --- Поиск ---
        "." = "search"; # /
        "," = "rsearch"; # ?
        "т" = "search_next"; # n
        "Т" = "search_prev"; # N
        "*" = "search_selection_detect_word_boundaries";
        "A-*" = "search_selection";

        # --- Режимы и Команды ---
        "Ж" = "command_mode"; # :
        "Э" = "select_register"; # "

        # --- Shell ---
        "|" = "shell_pipe";
        "A-|" = "shell_pipe_to";
        "!" = "shell_insert_output";
        "A-!" = "shell_append_output";
        "$" = "shell_keep_pipe";

        # --- Вложенные меню ---

        # -- Goto (g -> п) --
        "п" = {
          # g
          "п" = "goto_file_start"; # g
          "|" = "goto_column"; # |
          "у" = "goto_last_line"; # e
          "а" = "goto_file"; # f
          "р" = "goto_line_start"; # h
          "д" = "goto_line_end"; # l
          "ы" = "goto_first_nonwhitespace"; # s
          "в" = "goto_definition"; # d
          "В" = "goto_declaration"; # D
          "н" = "goto_type_definition"; # y
          "к" = "goto_reference"; # r
          "ш" = "goto_implementation"; # i
          "е" = "goto_window_top"; # t
          "с" = "goto_window_center"; # c
          "и" = "goto_window_bottom"; # b
          "ф" = "goto_last_accessed_file"; # a
          "ь" = "goto_last_modified_file"; # m
          "т" = "goto_next_buffer"; # n
          "з" = "goto_previous_buffer"; # p
          "л" = "move_line_up"; # k
          "о" = "move_line_down"; # j
          "ю" = "goto_last_modification"; # .
          "ц" = "goto_word"; # w
        };

        # -- Match (m -> ь) --
        "ь" = {
          # m
          "ь" = "match_brackets"; # m
          "ы" = "surround_add"; # s
          "к" = "surround_replace"; # r
          "в" = "surround_delete"; # d
          "ф" = "select_textobject_around"; # a
          "ш" = "select_textobject_inner"; # i
        };

        # -- Brackets ([ -> х) --
        "х" = {
          # [
          "в" = "goto_prev_diag"; # d
          "В" = "goto_first_diag"; # D
          "п" = "goto_prev_change"; # g
          "П" = "goto_first_change"; # G
          "а" = "goto_prev_function"; # f
          "е" = "goto_prev_class"; # t
          "ф" = "goto_prev_parameter"; # a
          "с" = "goto_prev_comment"; # c
          "у" = "goto_prev_entry"; # e
          "Е" = "goto_prev_test"; # T
          "з" = "goto_prev_paragraph"; # p
          # "ч" = "goto_prev_xml_element"; # x
          "space" = "add_newline_above";
        };

        # -- Brackets (] -> ъ) --
        "ъ" = {
          # ]
          "в" = "goto_next_diag"; # d
          "В" = "goto_last_diag"; # D
          "п" = "goto_next_change"; # g
          "П" = "goto_last_change"; # G
          "а" = "goto_next_function"; # f
          "е" = "goto_next_class"; # t
          "ф" = "goto_next_parameter"; # a
          "с" = "goto_next_comment"; # c
          "у" = "goto_next_entry"; # e
          "Е" = "goto_next_test"; # T
          "з" = "goto_next_paragraph"; # p
          # "ч" = "goto_next_xml_element"; # x
          "space" = "add_newline_below";
        };

        # -- Window (C-w -> C-ц) --
        "C-ц" = {
          # C-w
          "C-ц" = "rotate_view"; # C-w
          "ц" = "rotate_view"; # w
          "C-ы" = "hsplit"; # C-s
          "ы" = "hsplit"; # s
          "C-м" = "vsplit"; # C-v
          "м" = "vsplit"; # v
          "C-е" = "transpose_view"; # C-t
          "е" = "transpose_view"; # t
          "а" = "goto_file_hsplit"; # f
          "А" = "goto_file_vsplit"; # F
          "C-й" = "wclose"; # C-q
          "й" = "wclose"; # q
          "C-щ" = "wonly"; # C-o
          "щ" = "wonly"; # o
          "C-р" = "jump_view_left"; # C-h
          "р" = "jump_view_left"; # h
          "C-о" = "jump_view_down"; # C-j
          "о" = "jump_view_down"; # j
          "C-л" = "jump_view_up"; # C-k
          "л" = "jump_view_up"; # k
          "C-д" = "jump_view_right"; # C-l
          "д" = "jump_view_right"; # l
          "Д" = "swap_view_right"; # L
          "Л" = "swap_view_up"; # K
          "Р" = "swap_view_left"; # H
          "О" = "swap_view_down"; # J
          "т" = {
            # n
            "C-ы" = "hsplit_new"; # C-s
            "ы" = "hsplit_new"; # s
            "C-м" = "vsplit_new"; # C-v
            "м" = "vsplit_new"; # v
          };
        };

        # -- View (z -> я) --
        "я" = {
          # z
          "я" = "align_view_center"; # z
          "с" = "align_view_center"; # c
          "е" = "align_view_top"; # t
          "и" = "align_view_bottom"; # b
          "ь" = "align_view_middle"; # m
          "л" = "scroll_up"; # k
          "о" = "scroll_down"; # j
          "C-и" = "page_up"; # C-b
          "C-а" = "page_down"; # C-f
          "C-г" = "page_cursor_half_up"; # C-u
          "C-в" = "page_cursor_half_down"; # C-d
          "." = "search"; # /
          "," = "rsearch"; # ?
          "т" = "search_next"; # n
          "Т" = "search_prev"; # N
        };

        # -- View Sticky (Z -> Я) --
        "Я" = {
          # Z
          "я" = "align_view_center"; # z
          "с" = "align_view_center"; # c
          "е" = "align_view_top"; # t
          "и" = "align_view_bottom"; # b
          "ь" = "align_view_middle"; # m
          "л" = "scroll_up"; # k
          "о" = "scroll_down"; # j
          "C-и" = "page_up"; # C-b
          "C-а" = "page_down"; # C-f
          "C-г" = "page_cursor_half_up"; # C-u
          "C-в" = "page_cursor_half_down"; # C-d
          "." = "search"; # /
          "," = "rsearch"; # ?
          "т" = "search_next"; # n
          "Т" = "search_prev"; # N
        };

        # -- Space --
        "space" = {
          "а" = "file_picker"; # f
          "А" = "file_picker_in_current_directory"; # F
          "у" = "file_explorer"; # e
          "У" = "file_explorer_in_current_buffer_directory"; # E
          "и" = "buffer_picker"; # b
          "о" = "jumplist_picker"; # j
          "ы" = "symbol_picker"; # s
          "Ы" = "workspace_symbol_picker"; # S
          "в" = "diagnostics_picker"; # d
          "В" = "workspace_diagnostics_picker"; # D
          "п" = "changed_file_picker"; # g
          "ф" = "code_action"; # a
          "э" = "last_picker"; # '
          "?" = "command_palette";
          "." = "global_search"; # /
          "н" = "yank_to_clipboard"; # y
          "Н" = "yank_main_selection_to_clipboard"; # Y
          "з" = "paste_clipboard_after"; # p
          "З" = "paste_clipboard_before"; # P
          "К" = "replace_selections_with_clipboard"; # R
          "л" = "hover"; # k
          "к" = "rename_symbol"; # r
          "р" = "select_references_to_symbol_under_cursor"; # h
          "с" = "toggle_comments"; # c
          "С" = "toggle_block_comments"; # C
          "A-с" = "toggle_line_comments"; # Alt-c

          # -- Space -> Debug (G -> П) --
          "П" = {
            # G
            "д" = "dap_launch"; # l
            "к" = "dap_restart"; # r
            "и" = "dap_toggle_breakpoint"; # b
            "с" = "dap_continue"; # c
            "р" = "dap_pause"; # h
            "ш" = "dap_step_in"; # i
            "щ" = "dap_step_out"; # o
            "т" = "dap_next"; # n
            "м" = "dap_variables"; # v
            "е" = "dap_terminate"; # t
            "C-с" = "dap_edit_condition"; # C-c
            "C-д" = "dap_edit_log"; # C-l
            "ы" = {
              # s
              "е" = "dap_switch_thread"; # t
              "а" = "dap_switch_stack_frame"; # f
            };
            "у" = "dap_enable_exceptions"; # e
            "У" = "dap_disable_exceptions"; # E
          };

          # -- Space -> Window (w -> ц) --
          # (дублирует C-w)
          "ц" = {
            # w
            "C-ц" = "rotate_view"; # C-w
            "ц" = "rotate_view"; # w
            "C-ы" = "hsplit"; # C-s
            "ы" = "hsplit"; # s
            "C-м" = "vsplit"; # C-v
            "м" = "vsplit"; # v
            "C-е" = "transpose_view"; # C-t
            "е" = "transpose_view"; # t
            "а" = "goto_file"; # f
            "А" = "goto_file"; # F
            "C-й" = "wclose"; # C-q
            "й" = "wclose"; # q
            "C-щ" = "wonly"; # C-o
            "щ" = "wonly"; # o
            "C-р" = "jump_view_left"; # C-h
            "р" = "jump_view_left"; # h
            "C-о" = "jump_view_down"; # C-j
            "о" = "jump_view_down"; # j
            "C-л" = "jump_view_up"; # C-k
            "л" = "jump_view_up"; # k
            "C-д" = "jump_view_right"; # C-l
            "д" = "jump_view_right"; # l
            "Д" = "swap_view_right"; # L
            "Л" = "swap_view_up"; # K
            "Р" = "swap_view_left"; # H
            "О" = "swap_view_down"; # J
            "т" = {
              # n
              "C-ы" = "hsplit_new"; # C-s
              "ы" = "hsplit_new"; # s
              "C-м" = "vsplit_new"; # C-v
              "м" = "vsplit_new"; # v
            };
          };
        };
      }; # keys.normal

      # #################
      # INSERT MODE
      # #################

      insert = {
        "esc" = "normal_mode";
        "C-ы" = "commit_undo_checkpoint"; # C-s
        "C-ч" = "completion"; # C-x
        "C-к" = "insert_register"; # C-r
        "C-ц" = "delete_word_backward"; # C-w
        "A-в" = "delete_word_forward"; # A-d
        "C-г" = "kill_to_line_start"; # C-u
        "C-л" = "kill_to_line_end"; # C-k
        "C-р" = "delete_char_backward"; # C-h
        "C-в" = "delete_char_forward"; # C-d
        "C-о" = "insert_newline"; # C-j
      }; # keys.insert

      # #################
      # SELECT MODE
      # #################

      select = {
        "р" = "extend_char_left"; # h
        "о" = "extend_visual_line_down"; # j
        "л" = "extend_visual_line_up"; # k
        "д" = "extend_char_right"; # l
        "ц" = "extend_next_word_start"; # w
        "и" = "extend_prev_word_start"; # b
        "у" = "extend_next_word_end"; # e
        "Ц" = "extend_next_long_word_start"; # W
        "И" = "extend_prev_long_word_start"; # B
        "У" = "extend_next_long_word_end"; # E
        "A-у" = "extend_parent_node_end"; # A-e
        "A-и" = "extend_parent_node_start"; # A-b
        "т" = "extend_search_next"; # n
        "Т" = "extend_search_prev"; # N
        "е" = "extend_till_char"; # t
        "а" = "extend_next_char"; # f
        "Е" = "extend_till_prev_char"; # T
        "А" = "extend_prev_char"; # F
        "home" = "extend_to_line_start";
        "end" = "extend_to_line_end";
        "esc" = "exit_select_mode";
        "м" = "normal_mode"; # v

        "п" = {
          # g
          "п" = "extend_to_file_start"; # g
          "|" = "extend_to_column"; # |
          "у" = "extend_to_last_line"; # e
          "л" = "extend_line_up"; # k
          "о" = "extend_line_down"; # j
          "ц" = "extend_to_word"; # w
        };

        "space" = {
          "а" = "file_picker"; # f
          "А" = "file_picker_in_current_directory"; # F
          "у" = "file_explorer"; # e
          "У" = "file_explorer_in_current_buffer_directory"; # E
          "и" = "buffer_picker"; # b
          "о" = "jumplist_picker"; # j
          "ы" = "symbol_picker"; # s
          "Ы" = "workspace_symbol_picker"; # S
          "в" = "diagnostics_picker"; # d
          "В" = "workspace_diagnostics_picker"; # D
          "п" = "changed_file_picker"; # g
          "ф" = "code_action"; # a
          "э" = "last_picker"; # '
          "?" = "command_palette";
          "." = "global_search"; # /
          "н" = "yank_to_clipboard"; # y
          "Н" = "yank_main_selection_to_clipboard"; # Y
          "з" = "paste_clipboard_after"; # p
          "З" = "paste_clipboard_before"; # P
          "К" = "replace_selections_with_clipboard"; # R
          "л" = "hover"; # k
          "к" = "rename_symbol"; # r
          "р" = "select_references_to_symbol_under_cursor"; # h
          "с" = "toggle_comments"; # c
          "С" = "toggle_block_comments"; # C
          "A-с" = "toggle_line_comments"; # Alt-c
        };
      }; # select
    }; # keys
  }; # programs

} # main
