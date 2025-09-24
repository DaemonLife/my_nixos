{
  description = "DaemonLife's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    nixpkgs-unstable,
    nixos-hardware,
    nvf,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    # Creating configuration function
    mkNixosConfig = device: {
      inherit system;
      modules = builtins.concatLists [
        [
          ./configuration.nix # main config
          ./devices/${device}/configuration.nix # device config
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user.imports = [
              nvf.homeManagerModules.default
              ./home.nix # main home config
              ./devices/${device}/home.nix # device home config
            ];
            home-manager.backupFileExtension = "bkp";
          }
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
        (
          if device == "gpd-pocket-3"
          then [nixos-hardware.nixosModules.${device}]
          else [] # If there is no hardware module
        )
      ];
    };
  in {
    nixosConfigurations = {
      # create configurations for my devices
      gpd-pocket-3 = nixpkgs.lib.nixosSystem (mkNixosConfig "gpd-pocket-3");
      lenovo = nixpkgs.lib.nixosSystem (mkNixosConfig "lenovo");
    }; # end of nixosConfigurations
  }; # end of outputs
}
