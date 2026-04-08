{ config, lib, pkgs, ... }:
with config.lib.stylix.colors; let
  telegram_experimental_options = ''
    {
      "fractional-scaling-enabled": false,
      "send-large-photos": true
    }
  '';

  settings = ''
    {
        "appIcon": "default",
        "channelBottomButton": 2,
        "collapseSimilarChannels": true,
        "deletedMark": "🧹",
        "disableAds": true,
        "disableCustomBackgrounds": false,
        "disableNotificationsDelay": false,
        "disableStories": true,
        "editedMark": "edited",
        "gifConfirmation": false,
        "hideAllChatsFolder": true,
        "hideFromBlocked": false,
        "hideNotificationBadge": false,
        "hideNotificationCounters": false,
        "hideSimilarChannels": true,
        "increaseWebviewHeight": false,
        "increaseWebviewWidth": false,
        "localPremium": false,
        "markReadAfterAction": true,
        "monoFont": "",
        "recentStickersCount": 100,
        "replaceBottomInfoWithIcons": true,
        "saveDeletedMessages": true,
        "saveForBots": false,
        "saveMessagesHistory": true,
        "sendOfflinePacketAfterOnline": false,
        "sendOnlinePackets": true,
        "sendReadMessages": true,
        "sendReadStories": true,
        "sendUploadProgress": true,
        "sendWithoutSound": false,
        "showAttachButtonInMessageField": true,
        "showAttachPopup": true,
        "showAutoDeleteButtonInMessageField": true,
        "showCommandsButtonInMessageField": true,
        "showEmojiButtonInMessageField": true,
        "showEmojiPopup": true,
        "showGhostToggleInDrawer": true,
        "showGhostToggleInTray": true,
        "showHideMessageInContextMenu": 0,
        "showLReadToggleInDrawer": false,
        "showMessageDetailsInContextMenu": 2,
        "showMessageSeconds": false,
        "showMessageShot": true,
        "showMicrophoneButtonInMessageField": true,
        "showPeerId": 2,
        "showReactionsPanelInContextMenu": 1,
        "showSReadToggleInDrawer": true,
        "showStreamerToggleInDrawer": false,
        "showStreamerToggleInTray": false,
        "showUserMessagesInContextMenu": 2,
        "showViewsPanelInContextMenu": 1,
        "simpleQuotesAndReplies": false,
        "spoofWebviewAsAndroid": false,
        "stickerConfirmation": false,
        "useScheduledMessages": false,
        "voiceConfirmation": false,
        "wideMultiplier": 1.0
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
  home.packages = with pkgs; [ ayugram-desktop ];
  home.activation.telegram_ayugram = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.local/share/AyuGramDesktop/tdata
    cd $HOME/.local/share/AyuGramDesktop/tdata

    # create binds
    echo '${telegram_binds}' > shortcuts-custom.json

    # create experimental options
    echo '${telegram_experimental_options}' > experimental_options.json

    # create settings
    echo '${settings}' > ayu_settings.json
  '';

}
