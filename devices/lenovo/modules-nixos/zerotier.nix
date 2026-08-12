{ ... }: {
  services.zerotierone = {
    enable = true;
    port = 9993;
  };

  networking.firewall = {
    allowedTCPPorts = [
      9993 # main
    ];
    allowedUDPPorts = [
      9993 # main
    ];
  };

}

