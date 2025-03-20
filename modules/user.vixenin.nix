{ config, pkgs, ... }:

{
  # User configuration
  users.users.vixenin = {
    isNormalUser = true;
    description = "Vixenin";
    
    # Extra group "gamemode" required since gamemode 1.8 to change CPU governor
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
  };

  # Set time zone
  time.timeZone = "Europe/Berlin";

  # Set internationalization properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";
}
