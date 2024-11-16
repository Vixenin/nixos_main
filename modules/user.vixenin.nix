{ config, pkgs, ... }:

{
  # User Configuration
  users.users.vixenin = {
    isNormalUser = true;
    description = "Vixenin";
    
    # extragroup "gamemode" required since gamemode 1.8 to change CPU governor
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  # Timezone and Locale Settings
  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
}
