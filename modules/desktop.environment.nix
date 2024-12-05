{ config, pkgs, ... }:

{
  # Desktop and display manager
  services.xserver = {
    enable = true;

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

  # Enable lavd scheduler
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [ "--performance" ];
  };
}
