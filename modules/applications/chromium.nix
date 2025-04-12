{ config, pkgs, ... }:

{
  programs = {
    chromium.enable = true;
  };

  # Enable chromum drm content
  nixpkgs.config = {
    chromium = {
      enableWideVine = true;
    };
  };
}