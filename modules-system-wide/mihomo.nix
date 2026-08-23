{
  pkgs,
  config,
  lib,
  ...
}: {
  services.mihomo = {
    enable = true;
    # tunMode = true; # даёт сервису права CAP_NET_ADMIN и т.п.
    configFile = "/etc/mihomo/config.yaml";
  };

  networking.firewall.trustedInterfaces = ["utun"]; # имя tun-интерфейса из конфига mihomo
  # networking.firewall.checkReversePath = false; # если увидишь "refuse" в dmesg
}
