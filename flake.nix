{
  description = "DaemonLife's flake";
  inputs = {
    # --- universal --- #

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- stable branch (and support unstable pkgs) --- #

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- only unstable branch --- #

    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    nvf,
    ...
  }: let
    user = "user";
    system = "x86_64-linux";

    # Configuration make function
    mkNixosConfig = device: {
      inherit system;
      specialArgs.username = user;
      modules = builtins.concatLists [
        [
          ./configuration.nix # main config
          ./devices/${device}/configuration.nix # device config
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs.username = user;
              users.${user}.imports = [
                ./home.nix # main home config
                ./devices/${device}/home.nix # device home config
              ];
              backupFileExtension = "bkp";
              sharedModules = [nvf.homeManagerModules.default];
            };
          }

          # unstable pkgs support
          {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
        ]

        # Add device module from flake hardware
        # (if device == "gpd-pocket-3"
        # then [ nixos-hardware.nixosModules.${device} ]
        # If there is no hardware module
        # else [ ])
      ];
    };
  in {
    # create configurations for my devices
    nixosConfigurations = {
      gpd-pocket-3 = nixpkgs.lib.nixosSystem (mkNixosConfig "gpd-pocket-3");
      lenovo = nixpkgs.lib.nixosSystem (mkNixosConfig "lenovo");
    };
  };
}
