{
  description = "DaemonLife's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , stylix
    , nixpkgs-unstable
    , nixos-hardware
    , nixvim
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      user = "user";

      # Creating configuration function
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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs.username = user;
              home-manager.users.${user}.imports = [
                ./home.nix # main home config
                ./devices/${device}/home.nix # device home config
              ];
              home-manager.backupFileExtension = "bkp";
              home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
            }
            # unstable pkgs
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
                })
              ];
            }
          ]
          # Add device module from flake hardware
          (if device == "gpd-pocket-3"
          then [ nixos-hardware.nixosModules.${device} ]
          # If there is no hardware module
          else [ ])
        ];
      };
    in
    {
      # create configurations for my devices
      nixosConfigurations = {
        gpd-pocket-3 = nixpkgs.lib.nixosSystem (mkNixosConfig "gpd-pocket-3");
        lenovo = nixpkgs.lib.nixosSystem (mkNixosConfig "lenovo");
      };
    };
}
