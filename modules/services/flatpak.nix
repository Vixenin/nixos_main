{ config, pkgs, ... }:

{
  # Install flatpak & flatbub repository
  services.flatpak.enable = true;
}