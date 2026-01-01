{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs";
    lwad-nixos = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "git+https://git.lwad.xyz/lwad/nixos?ref=main";
    };
  };
  outputs = inputs: {
    nixosConfigurations.hestia = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ./hardware-configuration.nix ];
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
    };
  };
}
