{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      overlay = final: prev: { };

      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; };
          xcrysden = with pkgs; callPackage ./nix/xcrysden { };
        in
        {
          packages.default = xcrysden;
          apps.default = {
            type = "app";
            program = "${xcrysden}/bin/xcrysden";
          };
        };
    in

    { inherit overlay; } // inputs.flake-utils.lib.eachDefaultSystem perSystem;
}
