{ config, pkgs, ... }:

{
  # System packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    # Steam proton & wayland tweaks
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/vixenin/.steam/root/compatibilitytools.d";
    GAMESCOPE_WAYLAND_DISPLAY = "wayland-0";
  };

  environment.variables = {
    # Nvidia wayland tweaks
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Drm kernel driver 'nvidia-drm' fix
    VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json;

    # Nvidia 10gb shader cache
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "/home/vixenin/.nv_shader_cache";
    __GL_SHADER_DISK_CACHE_SIZE = "10737418240";

    # Wayland browser tweaks
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    # General settings
    EDITOR = "vscode";
    VISUAL = "vscode";
  };

  # Opentabletdriver
  hardware.opentabletdriver.enable = true;

  # Xbox controller support my beloved :3
  hardware.xone.enable = true;

  # Dconf values logic
  system.activationScripts.dconfSetup = {
    text = let
      dconfSettings = ''
        # Disable legacy tray for appindicator extension / xwayland fix
        dconf write /org/gnome/shell/extensions/appindicator/legacy-tray-enabled false

        # Disable gnome tablet input management
        dconf write /org/gnome/settings-daemon/plugins/peripherals/tablets/active false
      '';
      mangohudSettings = ''
        fps_limit=162
        fps_only=1
        font_size=20
        position=top-left
        text_color=FF69B4
        background_alpha=0
      '';
    in ''
      for user in /home/*; do
        if [ -d "$user" ]; then
          # Dconf setup
          mkdir -p "$user/.config/dconf"
          echo "${dconfSettings}" > "$user/.config/dconf/user-dconf"
          chown $(basename "$user") "$user/.config/dconf/user-dconf"

          # Mangohud setup
          mkdir -p "$user/.config/MangoHud"
          echo "${mangohudSettings}" > "$user/.config/MangoHud/MangoHud.conf"
          chown $(basename "$user") "$user/.config/MangoHud/MangoHud.conf"
        fi
      done
    '';
  };
}
