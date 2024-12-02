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

  # Make flatpak use vulkan layers
  systemd.services.flatpak-vulkan = {
    description = "Setup Vulkan Layers for Flatpak";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"export VK_LAYER_PATH=/run/current-system/sw/share/vulkan/explicit_layer.d\" >> /etc/environment'";
    };
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
