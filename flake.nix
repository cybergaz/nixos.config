{
  description = "cybergaz nixos + hm config";

  inputs = {
    # nixpkgs unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nix-index-database.url = "github:nix-community/nix-index-database";
    # nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # add home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # # zen-browser
    # zen-browser.url = "github:0xc000022070/zen-browser-flake";

    niri = {
      url = "github:niri-wm/niri/wip/branch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      niri,
      # nix-index-database,
      ...
    }@inputs:
    {
      # nixosModules.default = import ./modules/default.nix;
      nixosConfigurations = {
        # the name of the configuration is the same as the hostname of the machine
        cybergaz = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            # here goes your NixOS configuration as a NixOS module
            ./configuration.nix

            # bring in nix-index-database as a NixOS module
            # nix-index-database.nixosModules.default
            # { programs.nix-index-database.comma.enable = true; }

            # bring in home-manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "HMBackup";
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };

              home-manager.users.gaz.imports = [ ./home.nix ];
            }
          ];
        };
      };
    };
}
