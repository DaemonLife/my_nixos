{
  pkgs,
  config,
  lib,
  ...
}: {
  users.users."user2" = {
    isNormalUser = true;
    home = "/home/user2";
    description = "my user2";
    shell = pkgs.zsh;
    # useDefaultShell = true;
    createHome = true;
    # packages = with pkgs; [firefox];
    # initialPassword = "user2";
  };

  networking = {
    nftables.enable = true;

    localCommands = ''
      # Таблица 100: через tun0 (v2ray)
      ip route replace default dev tun0 table 100

      # Таблица 200: direct наружу (твой текущий default)
      ip route replace default via 192.168.1.1 dev enp8s0 table 200

      # fwmark -> таблица
      ip rule add fwmark 100 lookup 100 priority 1000 2>/dev/null || true
      ip rule add fwmark 200 lookup 200 priority 1001 2>/dev/null || true
    '';

    nftables.ruleset = ''
      table inet v2ray_policy {
        chain output {
          type filter hook output priority -150; policy accept;

          meta skuid 1001 meta mark set 200
          meta skuid != 1001 meta mark set 100
        }
      }
    '';
  };
}
