{
  description = "Home Manager configuration of the current user";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, home-manager, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        userConfig = (import ./config.nix { inherit system; });
        username = userConfig.username;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ rust-overlay.overlays.default ];
        };
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          ./common.nix
          ./dev.nix
          ./design.nix
          ./macos.nix
          ./server.nix
        ];
        baseConfig = modules: home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit modules;
          extraSpecialArgs = (import ./config.nix { inherit system; });
        };
      in
      {
        packages.homeConfigurations."${username}" = baseConfig (modules);
      } // {
        formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      }
    );
}
