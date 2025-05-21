{ config, pkgs, ... }:

let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  }) {
    config.allowUnfree = true;
  };
in
{
  # Libratbag daemon
  services.ratbagd.enable = true;

  # Piper
  environment.systemPackages = with pkgs; [
    unstable.piper
  ];
}
