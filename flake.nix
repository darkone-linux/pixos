{
  description = "PixOS";

  # Avoid building kernel
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {

    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Pin RPN
    raspberry-pi-nix = {
      url = "github:nix-community/raspberry-pi-nix?ref=v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Activate HM if needed
    #home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
        
  };

  outputs = { 
    self, 
    nixpkgs, 
    raspberry-pi-nix,
    #home-manager, 
    nixos-hardware, 
  ... }@inputs:

  let

    # Image name
    devices = {
      pi = "pixos";
    };
    
    # Function to import nixpkgs with architecture, unfree packages. 
    pkgsSettings = system: import nixpkgs { inherit system; config.allowUnfree = true; };
    
  in {
    nixosConfigurations = {
      ${devices.pi} = nixpkgs.lib.nixosSystem {
        pkgs = pkgsSettings "aarch64-linux";
        specialArgs = { inherit inputs; inherit devices; };
        modules = [
          ./configuration.nix
          raspberry-pi-nix.nixosModules.raspberry-pi
          nixos-hardware.nixosModules.raspberry-pi-5
        ];
      };
    };
  };
}
