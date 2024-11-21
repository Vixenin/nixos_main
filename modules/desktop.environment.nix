{ config, pkgs, ... }:

{
  # Desktop and display manager
  services.xserver = {
    enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };

    videoDrivers = [ "nvidia" ];

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
      };
    };

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [pkgs.gnome.mutter];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
      '';
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  services.displayManager.defaultSession = "gnome";
}
