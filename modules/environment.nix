{ config, pkgs, ... }:

{
  # System packages
  nixpkgs.config.allowUnfree = true;

  # Nix experimental 
  nix.settings.experimental-features = [ "nix-command" ];

  environment.variables = {
    # Wayland browser tweaks
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";

    # General settings
    EDITOR = "vscode";
    VISUAL = "vscode";
  };

  # Dconf values logic
  system.userActivationScripts.setupDconf = {
    text = ''
      dconfSettings=$(cat <<EOF

        # Disable legacy tray for appindicator extension / xwayland fix
        dconf write /org/gnome/shell/extensions/appindicator/legacy-tray-enabled false

        # Disable gnome tablet input management
        dconf write /org/gnome/settings-daemon/plugins/peripherals/tablets/active false
  EOF
      )

      # Dconf setup
      mkdir -p ~/.config/dconf
      echo "$dconfSettings" > ~/.config/dconf/user-dconf
    '';
  };
}
