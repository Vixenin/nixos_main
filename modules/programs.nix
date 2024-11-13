{ config, pkgs, ... }:

{
  # Enable Flatpak
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  programs = {
    # Firefox
    firefox.enable = true;

    # Steam
    steam = {
      enable = true;
      gamescopeSession.enable = true;

      # Fix gamescope inside steam
      package = pkgs.steam.override {
        extraLibraries = pkgs: with pkgs; [ libkrb5 keyutils ];
      };

      # Proton-ge inside steam options
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode.enable = true;
  };
}