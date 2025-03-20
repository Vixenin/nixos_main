{ config, pkgs, ... }:

{
  # Install flatpak & flatbub repository
  services.flatpak.enable = true;

  programs = {
    chromium.enable = true;

    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = -10;
        };
      };
    };

    gamescope = {
      enable = true;
      capSysNice = false;
    };

    steam = {
      enable = true;
      gamescopeSession.enable = true;

      # Proton-ge inside steam options
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };

  # Enable chromum drm content
  nixpkgs.config = {
   chromium = {
     enableWideVine = true;
    };
  };
}
