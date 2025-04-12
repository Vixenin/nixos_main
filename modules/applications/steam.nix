{ config, pkgs, ... }:

{
  # Steam proton & wayland tweaks
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    GAMESCOPE_WAYLAND_DISPLAY = "wayland-0";
  };

  programs = {
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
    };
  };
}