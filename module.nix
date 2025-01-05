{withSystem, ...}: {
  flake.nixosModules.default = {
    lib,
    pkgs,
    config,
    system,
    ...
  }: {
    imports = [
      (
        {
          lib,
          config,
          ...
        }: let
          cfg = config.services.wolhttp;
        in {
          options.services.wolhttp = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            package = lib.mkOption {
              defaultText = lib.literalMD "`packages.default` from the wolhttp flake";
            };
            port = lib.mkOption {
              type = lib.types.number;
              default = 9023;
            };
          };
          config = lib.mkIf cfg.enable {
            systemd.services.wolhttp = {
              description = "wolhttp";
              environment = {
                PORT = toString cfg.port;
              };
              script = ''
                ${cfg.package}/bin/main.py
              '';
              wantedBy = ["multi-user.target"];
              stopIfChanged = true;
            };
          };
        }
      )
    ];
    services.wolhttp.package = withSystem pkgs.stdenv.hostPlatform.system (
      {config, ...}:
        config.packages.default
    );
  };
}
