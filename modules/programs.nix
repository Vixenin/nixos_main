{ config, pkgs, ... }:

{
  # Install flatpak & flatbub repository
  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    description = "Add Flathub Beta Flatpak Repository";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

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
