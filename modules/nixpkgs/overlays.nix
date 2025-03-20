{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      vPack = {
        r2modman = import ./r2modman/package.nix {
          inherit (super) lib stdenv yarn fetchYarnDeps fixup-yarn-lock nodejs electron fetchFromGitHub nix-update-script makeWrapper makeDesktopItem copyDesktopItems;
        };
      };
    })
  ];
}
