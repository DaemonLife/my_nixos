# Description

My Sway (and Hyprland, Niri, i3) setup on NixOS.

## Preparing

1. Change username "user" in configs if you use other name. Also change hostname
   if you need. I use "nixos".
2. Place all configs to /home/$USER/nix and open this nix folder.

## Install

I have two configurated **devices**:

- GPD pocket 3 ("**gpd-pocket-3**")
- IdeaPad 5 Pro 14ACN ("**lenovo**")

For Lenovo run: `nixos-rebuild switch --flake . #lenovo`\
For GPD: `nixos-rebuild switch --flake . #gpd-pocket-3`

If you use other then for quickly start I recommend you remove file
.../nix/devices/lenovo/hardware-configuration.nix and after all run:

```
cp /etc/nixos/hardware-configuration.nix /home/$USER/nix/devices/lenovo/
nixos-rebuild switch --flake . #lenovo
```

If file /etc/nixos/hardware-configuration.nix don't exist then run next command
and repeat:\
`sudo nixos-generate-config`

Reboot. Done.

## Using

For rebuild use: `os [switch|test|boot]`\
For update and rebuild: `os [switch|test|boot] update`\
Force offline rebuild: `os [switch|test|boot] offline`

## Tips

To set up your Telegram auto-update theme, follow these steps:

1. Open "Settings/Chat Settings" in Telegram Desktop application.
2. Click on the three dots in the top right corner and select "Create theme".
3. Choose "Import existing theme" and select the file (available after the first
   home build) in "~/.config/telegram-base16.tdesktop-theme".
