{ config, pkgs, ... }:

{
  # Enable flatpak
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    description = "Add Flathub Beta Flatpak Repository";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --user --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    '';
  };

  # Install discord canary with wayland support
  systemd.services.discord-canary = {
    description = "Install Discord Canary and configure Wayland support";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak install -y com.discordapp.DiscordCanary
      flatpak override --user --socket=wayland com.discordapp.DiscordCanary
    '';
  };

  programs = {
    # Firefox
    firefox.enable = true;

    # Gamemode
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

    # Gamescope
    gamescope = {
      enable = true;
      capSysNice = false;
    };

    # Steam
    steam = {
      enable = true;
      gamescopeSession.enable = true;

      # Proton-ge inside steam options
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };
}
