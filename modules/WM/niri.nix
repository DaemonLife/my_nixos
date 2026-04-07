{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    (import ./waybar.nix {
      inherit config lib;
      MY_DE = "niri";
    })
    ./mako.nix
    ./fuzzel.nix
    ./swaylock.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    swayidle
    swaybg
    # xwayland-satellite # x11 support
    niri
  ];

  home.file.".config/niri/config.kdl".text = with config.lib.stylix.colors;
  # kdl
    ''
      prefer-no-csd
      input {
          keyboard {
              xkb {
                  layout "us,ru"
                  options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"

              }
              repeat-delay 200
              repeat-rate 60
              numlock
          }

          touchpad {
              tap
              drag false
              natural-scroll
          }

          // Uncomment this to make the mouse warp to the center of newly focused windows.
          warp-mouse-to-focus
          focus-follows-mouse max-scroll-amount="90%"
      }

      // Run `niri msg outputs`
      output "Shenzhen KTC Technology Group H27S17 0x00000001" {
        scale 1.25
        position x=0 y=0
      }

      output "BOE 0x0931 Unknown" {
          scale 2
          position x=2048 y=400
      }

      // gpd
      output "DSI-1" {
        transform "270"
      }

      layout {
          gaps 18
          center-focused-column "never"
          background-color "#${base03}"

          default-column-width { proportion 0.5; }
          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }
          preset-window-heights {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
          }

          focus-ring {
              // off
              width 4
              active-color "#${base0D}"
              inactive-color "#${base03}00"
          }

          border {
              off
              width 4
              active-color "#${base0D}"
              inactive-color "#${base00}"
              urgent-color "red"
          }

          shadow {
              on
              softness 0
              spread 1
              offset x=8 y=8
              draw-behind-window true
              color "#000f"
          }
      }

      spawn-at-startup "bluetooth" "off"
      spawn-at-startup "udiskie" "-a"
      spawn-at-startup "waybar"
      spawn-at-startup "mako"
      spawn-at-startup "swayidle" "-w" "timeout" "501" "niri msg action power-off-monitors" "timeout" "500" "swaylock -f" "before-sleep" "swaylock -f"

      hotkey-overlay {
        skip-at-startup
      }

      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      animations {
          // off
          // slowdown 3.0
      }

      window-rule {
        match title=""
        geometry-corner-radius 0
      }

      window-rule {
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          open-floating true
      }

      binds {
          // Most actions that you can bind here can also be invoked programmatically with
          // `niri msg action do-something`.

          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+Return hotkey-overlay-title="Open a Terminal: kitty" { spawn "kitty"; }
          Mod+A hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel" "-l" "10"; }
          Mod+T hotkey-overlay-title="Run an Application: Telegram" { spawn "telegram-desktop"; }
          Mod+B hotkey-overlay-title="Run an Application: qutebrowser" { spawn "qutebrowser"; }
          Mod+N hotkey-overlay-title="Run an Application: Thunar" { spawn "thunar"; }
          Mod+Y hotkey-overlay-title="Run an Application: Yazi" { spawn "sh" "-c" "kitty --hold $HOME/nix/scripts/y.fish"; }
          Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }

          // You can also use a shell. Do this if you need pipes, multiple commands, etc.
          // Super+Alt+S hotkey-overlay-title=null { spawn "sh" "-c" "pkill orca || exec orca"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn "amixer" "sset" "'Master'" "5%+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "amixer" "sset" "'Master'" "5%-"; }
          Ctrl+j allow-when-locked=true { spawn "amixer" "sset" "'Master'" "5%+"; }
          Ctrl+k allow-when-locked=true { spawn "amixer" "sset" "'Master'" "5%-"; }
          XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

          XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+5%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "5%-"; }
          Ctrl+l allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+5%"; }
          Ctrl+h allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "5%-"; }

          // Open/close the Overview: a zoomed-out view of workspaces and windows.
          // You can also move the mouse into the top-left hot corner,
          // or do a four-finger swipe up on a touchpad.
          Mod+O repeat=false { toggle-overview; }

          Mod+Q repeat=false { close-window; }

          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }
          // Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+J     { move-window-down; }
          Mod+Ctrl+K     { move-window-up; }
          // Mod+Ctrl+L     { move-column-right; }

          // Alternative commands that move across workspaces when reaching
          // the first or last window in a column.
          // Mod+J     { focus-window-or-workspace-down; }
          // Mod+K     { focus-window-or-workspace-up; }
          // Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
          // Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          Mod+Shift+Left  { focus-monitor-left; }
          Mod+Shift+Down  { focus-monitor-down; }
          Mod+Shift+Up    { focus-monitor-up; }
          Mod+Shift+Right { focus-monitor-right; }
          Mod+Shift+H     { focus-monitor-left; }
          Mod+Shift+J     { focus-monitor-down; }
          Mod+Shift+K     { focus-monitor-up; }
          Mod+Shift+L     { focus-monitor-right; }

          Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
          // ...

          // And you can also move a whole workspace to another monitor:
          // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
          // ...

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+U              { focus-workspace-down; }
          Mod+I              { focus-workspace-up; }
          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+U         { move-column-to-workspace-down; }
          Mod+Ctrl+I         { move-column-to-workspace-up; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
          // ...

          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }

          // You can bind mouse wheel scroll ticks using the following syntax.
          // These binds will change direction based on the natural-scroll setting.
          //
          // To avoid scrolling through workspaces really fast, you can use
          // the cooldown-ms property. The bind will be rate-limited to this value.
          // You can set a cooldown on any bind, but it's most useful for the wheel.
          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft  { move-column-left; }

          // Usually scrolling up and down with Shift in applications results in
          // horizontal scrolling; these binds replicate that.
          Mod+Shift+WheelScrollDown      { focus-column-right; }
          Mod+Shift+WheelScrollUp        { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

          // Similarly, you can bind touchpad scroll "ticks".
          // Touchpad scrolling is continuous, so for these binds it is split into
          // discrete intervals.
          // These binds are also affected by touchpad's natural-scroll, so these
          // example binds are "inverted", since we have natural-scroll enabled for
          // touchpads by default.
          // Mod+TouchpadScrollDown { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
          // Mod+TouchpadScrollUp   { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }

          // You can refer to workspaces by index. However, keep in mind that
          // niri is a dynamic workspace system, so these commands are kind of
          // "best effort". Trying to refer to a workspace index bigger than
          // the current workspace count will instead refer to the bottommost
          // (empty) workspace.
          //
          // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
          // will all refer to the 3rd workspace.
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Ctrl+1 { move-window-to-workspace 1; }

          // Switches focus between the current and the previous workspace.
          // Mod+Tab { focus-workspace-previous; }

          // The following binds move the focused window in and out of a column.
          // If the window is alone, they will consume it into the nearby column to the side.
          // If the window is already in a column, they will expel it out.
          Mod+Ctrl+h  { consume-or-expel-window-left; }
          Mod+Ctrl+l { consume-or-expel-window-right; }

          // Consume one window from the right to the bottom of the focused column.
          Mod+Comma  { consume-window-into-column; }
          // Expel the bottom window from the focused column to the right.
          Mod+Period { expel-window-from-column; }

          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }

          // Expand the focused column to space not taken up by other fully visible columns.
          // Makes the column "fill the rest of the space".
          Mod+Ctrl+F { expand-column-to-available-width; }

          Mod+C { center-column; }

          // Center all fully visible columns on screen.
          Mod+Ctrl+C { center-visible-columns; }

          // Finer width adjustments.
          // This command can also:
          // * set width in pixels: "1000"
          // * adjust width in pixels: "-5" or "+5"
          // * set width as a percentage of screen width: "25%"
          // * adjust width as a percentage of screen width: "-10%" or "+10%"
          // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
          // set-column-width "100" will make the column occupy 200 physical screen pixels.
          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }

          // Finer height adjustments when in column with other windows.
          Mod+Shift+Minus { set-window-height "-5%"; }
          Mod+Shift+Equal { set-window-height "+5%"; }

          // Move the focused window between the floating and the tiling layout.
          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }

          // Toggle tabbed column display mode.
          // Windows in this column will appear as vertical tabs,
          // rather than stacked on top of each other.
          Mod+W { toggle-column-tabbed-display; }

          // Actions to switch layouts.
          // Note: if you uncomment these, make sure you do NOT have
          // a matching layout switch hotkey configured in xkb options above.
          // Having both at once on the same hotkey will break the switching,
          // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
          // Mod+Space       { switch-layout "next"; }
          // Mod+Shift+Space { switch-layout "prev"; }

          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          // Applications such as remote-desktop clients and software KVM switches may
          // request that niri stops processing the keyboard shortcuts defined here
          // so they may, for example, forward the key presses as-is to a remote machine.
          // It's a good idea to bind an escape hatch to toggle the inhibitor,
          // so a buggy application can't hold your session hostage.
          //
          // The allow-inhibiting=false property can be applied to other binds as well,
          // which ensures niri always processes them, even when an inhibitor is active.
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          Mod+Shift+E { quit; }
          Ctrl+Alt+Delete { quit; }

          Mod+Shift+P { power-off-monitors; }

      }

        environment {
        }

    '';
}
