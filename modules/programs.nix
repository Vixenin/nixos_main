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

    # Gamemode
    gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          softrealtime = "auto";
          renice = -10;
        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Gamemode on'";
          end = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Gamemode off'";
        };
      };
    };

    # Gamescope
    gamescope = {
      enable = true;
      capSysNice = true;
    };

    # Steam
    steam = {
      enable = true;
      gamescopeSession.enable = true;

      # Fix gamescope inside steam
      package = pkgs.steam.override {
        extraLibraries = pkgs: with pkgs; [libkrb5 keyutils];
      };

      # Fix gamemode error + mangohud in steam
      extraPackages = pkgs: with pkgs; [ gamemode mangohud ];

      # Proton-ge inside steam options
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
