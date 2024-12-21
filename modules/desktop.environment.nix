{ config, pkgs, ... }:

{
  # Desktop and display manager
  services.xserver = {
    enable = true;

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
      };
    };

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [pkgs.mutter];
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

  # Enable system76 scheduler
  services.system76-scheduler = {
    enable = true;
  };
}
