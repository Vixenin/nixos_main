{ config, pkgs, ... }:

{
  # Desktop and display manager
  services = {
    xserver = {
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

    displayManager.defaultSession = "gnome";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
