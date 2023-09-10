{
  description = "CONFIGURE-ME";

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.devshell.url = "github:numtide/devshell";
  #inputs.nixpkgs.follows = "std/nixpkgs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.mach-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.pypi-deps-db = {
    url = "github:DavHau/pypi-deps-db";
    flake = false;
  };
  inputs.mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
  inputs.mach-nix.url = "github:DavHau/mach-nix";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.FastestRPLidar = {
    url = "github:purepani/FastestRplidar";
    inputs.mach-nix.follows = "mach-nix";
  };

  inputs.rplidar_sdk = {
    url = "github:Slamtec/rplidar_sdk";
    flake = false;
  };
  inputs.devenv.url = "github:cachix/devenv";
  inputs.nixpkgs-python.url = "github:cachix/nixpkgs-python";

  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        # Development Environments
        (nixago "configs")
        (devshells "shells")
        #(functions "FastestRplidar")
        (installables "package")
      ];
    }
    {
      devShells = std.harvest inputs.self ["repo" "shells"];
    };
}
