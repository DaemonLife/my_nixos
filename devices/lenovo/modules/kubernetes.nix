{ pkgs, ... }: {

  home.packages = with pkgs; [
    kubernetes
    virtualbox
  ];

}

