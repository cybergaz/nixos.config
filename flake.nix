{
  description = "cybergaz nixos + hm config";

  inputs = {
    # nixpkgs unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # add home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zen-browser
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.cybergaz = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

        # bring in home-manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "HMBackup";
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };

          home-manager.users.gaz.imports = [ ./home.nix ];
        }
      ];
    };
  };
}
