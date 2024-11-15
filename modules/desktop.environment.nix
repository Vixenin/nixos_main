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

  services.displayManager.defaultSession = "gnome";
}