{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      vPack = {
        r2modman = import ./r2modman/package.nix {
          inherit (super) lib stdenv yarn fetchYarnDeps fixup-yarn-lock nodejs electron fetchFromGitHub nix-update-script makeWrapper makeDesktopItem copyDesktopItems;
        };
        vintagestory = import ./vintagestory/package.nix {
          inherit (super) lib stdenv fetchurl makeWrapper makeDesktopItem copyDesktopItems xorg gtk2 sqlite openal cairo libGLU SDL2 freealut libglvnd pipewire libpulseaudio dotnet-runtime_8;
        };
      };
    })
  ];
}
