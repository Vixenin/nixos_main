{ config, pkgs, ... }:

{
  # System Packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    # Wayland browser tweaks
    NIXOS_OZONE_WL = "1";

    # Steam proton & wayland tweaks
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/vixenin/.steam/root/compatibilitytools.d";
    GAMESCOPE_WAYLAND_DISPLAY = "wayland-0";
  };

  environment.variables = {
    # Default text editor
    EDITOR = "vscode";
    VISUAL = "vscode";

    # Nvidia wayland tweaks
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Opentabletdriver
  hardware.opentabletdriver.enable = true;

  # Dconf values logic
  system.activationScripts.dconfSetup = {
    text = let
      dconfSettings = ''
        # Disable legacy tray for AppIndicator extension / xwayland fix
        dconf write /org/gnome/shell/extensions/appindicator/legacy-tray-enabled false

        # Disable gnome tablet input management / opentabletdriver mapping fix
        dconf write /org/gnome/settings-daemon/plugins/peripherals/tablets/active false
      '';
    in ''
      for user in /home/*; do
        if [ -d "$user" ]; then
          mkdir -p "$user/.config/dconf"
          echo "${dconfSettings}" > "$user/.config/dconf/user-dconf"
          chown $(basename "$user") "$user/.config/dconf/user-dconf"
        fi
      done
    '';
  };
}
