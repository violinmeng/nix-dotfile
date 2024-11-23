{
  description = "Personal NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      system = "aarch64-darwin";  # Changed from x86_64-darwin to aarch64-darwin for Apple Silicon
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # Enable experimental features for M1/M2 support
          experimental-features = [ "nix-command" "flakes" ];
          # Add Rosetta 2 support for x86_64 packages
          allowUnsupportedSystem = true;
        };
      };
    in {
      darwinConfigurations.default = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./macos
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${builtins.getEnv "USER"} = import ./modules;
          }
        ];
      };
    };
}
