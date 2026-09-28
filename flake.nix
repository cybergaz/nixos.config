{
  description = "cybergaz nixos + hm config";

  inputs = {
    # nixpkgs unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nix-index-database.url = "github:nix-community/nix-index-database";
    # nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # add home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # # zen-browser
    # zen-browser.url = "github:0xc000022070/zen-browser-flake";

    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # EgisTec EH57E fingerprint reader (patched libfprint + fprintd), see ~/workspace/fingerprint
    # fingerprint = {
    #   url = "path:/home/gaz/workspace/fingerprint";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # fff-nvim = {
    #   url = "github:dmtrKovalenko/fff.nvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprscape = {
      url = "github:cybergaz/hyprscape";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      flake-programs-sqlite,
      home-manager,
      niri,
      rust-overlay,
      # fff-nvim,
      # nix-index-database,
      hyprscape,
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
            flake-programs-sqlite.nixosModules.programs-sqlite
            { programs.command-not-found.enable = true; }

            # fingerprint reader: fprintd with the EH57E driver
            # inputs.fingerprint.nixosModules.default
            # {
            #   hardware.fingerprint.eh57e.enable = true;
            #   hardware.fingerprint.eh57e = {
            #     matchThreshold = "0.35";
            #     maxFailures = 15; # consecutive failed scans before lockout
            #     lockoutSeconds = 1; # how long fingerprint stays disabled
            #   };
            # }

            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ rust-overlay.overlays.default ];
                environment.systemPackages = [
                  pkgs.rust-bin.stable.latest.default
                  pkgs.rust-analyzer
                ];
              }
            )
            # (
            #   { pkgs, ... }:
            #   {
            #     environment.systemPackages = [
            #       fff-nvim.packages.x86_64-linux.default
            #     ];
            #   }
            # )

            # bring in home-manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "HMBackup";
              home-manager.extraSpecialArgs = {
                inherit inputs;
                # fff-nvim = inputs.fff-nvim; # or alternatively ""inherit (inputs) fff-nvim;""
              };

              home-manager.users.gaz.imports = [ ./home.nix ];
            }
          ];
        };
      };
    };
}
