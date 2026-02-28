{ config, lib, pkgs, ... }:
with config.lib.stylix.colors; let
  telegram_experimental_options = ''
    {
        "fractional-scaling-enabled": false,
        "send-large-photos": true
    }
  '';
  telegram_binds = ''
    // This is a list of changed shortcuts for Telegram Desktop
    // You can edit them in Settings > Chat Settings > Keyboard Shortcuts.
    [
        {
            "command": "search",
            "keys": "alt+/"
        },
        {
            "command": "show_contacts",
            "keys": "alt+c"
        },
        {
            "command": "next_chat",
            "keys": "alt+j"
        },
        {
            "command": "previous_chat",
            "keys": "alt+k"
        },
        {
            "command": "next_folder",
            "keys": "alt+shift+j"
        },
        {
            "command": "previous_folder",
            "keys": "alt+shift+k"
        }
    ]
  '';
in
{
  home.packages = with pkgs; [ telegram-desktop ];
  home.activation.telegram_desktop = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # create binds
    mkdir -p $HOME/.local/share/TelegramDesktop/tdata &&
    cd $HOME/.local/share/TelegramDesktop/tdata &&
    echo '${telegram_binds}' > shortcuts-custom.json

    # create experimental options
    echo '${telegram_experimental_options}' > experimental_options.json
  '';

}
