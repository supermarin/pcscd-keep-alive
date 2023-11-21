{
  inputs.nixpkgs.url = github:nixos/nixpkgs;
  inputs.flake-utils.url = github:numtide/flake-utils;
  outputs = { self, ... }@inputs: inputs.flake-utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.python3Packages.buildPythonPackage
          {
            name = "pcscd-keep-alive";
            version = "1.0.0";
            src = pkgs.lib.cleanSource ./.;
            propagatedBuildInputs = [ pkgs.python3Packages.pyscard ];
            format = "script";
            installPhase = ''
              mkdir -p $out/bin
              cp $src/main.py $out/bin/pcscd-keep-alive
            '';
          };
      }
    ) //
  {
    nixosModules.pcscd-keep-alive = { pkgs, config, lib, ... }:
      let
        cfg = config.services.pcscd-keep-alive;
      in
      {
        options.services.pcscd-keep-alive = {
          enable = lib.mkEnableOption "Enables pcscd keep-alive for yubikey PIN cache";
        };
        config = lib.mkIf cfg.enable {
          systemd.services.pcscd-keep-alive = {
            serviceConfig = {
              ExecStart = "${self.packages.${pkgs.system}.default}/bin/pcscd-keep-alive";
            };
            wantedBy = [ "multi-user.target" ];
          };
        };
      };
  };
}
