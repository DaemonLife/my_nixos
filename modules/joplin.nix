{ pkgs, ... }: {
  home.packages = with pkgs; [
    joplin-cli
    joplin-desktop
  ];

  # evil keymap for joplin-cli
  home.file.".config/joplin/keymap.json".text = ''
    [
    	{ "keys": [":"], "type": "function", "command": "enter_command_line_mode" },
    	{ "keys": ["TAB", "l"], "type": "function", "command": "focus_next" },
    	{ "keys": ["SHIFT_TAB", "h"], "type": "function", "command": "focus_previous" },
    	{ "keys": ["UP", "k"], "type": "function", "command": "move_up" },
    	{ "keys": ["DOWN", "j"], "type": "function", "command": "move_down" },
    	{ "keys": ["PAGE_UP", "CTRL_U", "gg"], "type": "function", "command": "page_up" },
    	{ "keys": ["PAGE_DOWN", "CTRL_D", "ge"], "type": "function", "command": "page_down" },
    	{ "keys": ["ENTER"], "type": "function", "command": "activate" },
    	{ "keys": ["DELETE", "BACKSPACE"], "type": "function", "command": "delete" },
    	{ "keys": [" "], "command": "todo toggle $n" },
    	{ "keys": ["n"], "type": "function", "command": "next_link" },
    	{ "keys": ["N"], "type": "function", "command": "previous_link" },
    	{ "keys": ["o"], "type": "function", "command": "open_link" },
    	{ "keys": ["tc"], "type": "function", "command": "toggle_console" },
    	{ "keys": ["tm"], "type": "function", "command": "toggle_metadata" },
    	{ "keys": ["/"], "type": "prompt", "command": "search \"\"", "cursorPosition": -2 },
    	{ "keys": ["mn"], "type": "prompt", "command": "mknote \"\"", "cursorPosition": -2 },
    	{ "keys": ["mt"], "type": "prompt", "command": "mktodo \"\"", "cursorPosition": -2 },
    	{ "keys": ["mb"], "type": "prompt", "command": "mkbook \"\"", "cursorPosition": -2 },
    	{ "keys": ["yn"], "type": "prompt", "command": "cp $n \"\"", "cursorPosition": -2 },
    	{ "keys": ["dn"], "type": "prompt", "command": "mv $n \"\"", "cursorPosition": -2 }
    ]
  '';
}

# how to sync in joplin-cli with dropbox:
# sync --target 7
