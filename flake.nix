{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./module.nix
      ];
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages.default = pkgs.python3Packages.buildPythonApplication {
          pname = "wolhttp";
          version = "1.0.0";

          propagatedBuildInputs = with pkgs.python3Packages; [
            flask
            wakeonlan
          ];

          src = ./.;
        };
        formatter = pkgs.alejandra;
      };
    };
}
