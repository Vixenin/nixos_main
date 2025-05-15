{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      vPack = {
        lact = self.callPackage ./lact/package.nix { };
        alchemy-viewer = self.callPackage ./alchemy-viewer/package.nix { };
        wlx-overlay-s = self.callPackage ./wlx-overlay-s/package.nix { };
      };
    })
  ];

  #enable lact and lactd.service

  environment.systemPackages = with pkgs; [
    vPack.lact
    vPack.alchemy-viewer 
    vPack.wlx-overlay-s
  ];

  systemd.services.lactd = {
    description = "LACT Daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.vPack.lact}/bin/lact daemon";
      Type = "simple";
      # Run as root since we need direct hardware access
      User = "root";
      Group = "root";
      Restart = "on-failure";
      RestartSec = "5";
      Environment = "LD_LIBRARY_PATH=/run/opengl-driver/lib";
    };
  };
}
