{
  inputs.nixpkgs.url = github:nixos/nixpkgs;
  outputs = self: inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.python3Packages.buildPythonPackage {
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

      nixosModules.pcscd-keep-alive = { config, pkgs, ... }:
        let
          cfg = config.services.pcscd-keep-alive;
        in
        {
          imports = [ ];
          options = {
            enable = pkgs.lib.mkEnableOption "Enables pcscd keep-alive for yubikey PIN cache";
          };
          config = pkgs.lib.mkIf cfg.enable {
            systemd.services."pcscd-keep-alive" = {
              wantedBy = [ "multi-user.target" ];
              script = "${self.packages.${system}}/bin/pcsdc-keep-alive";
            };
          };
        };
    };
}

