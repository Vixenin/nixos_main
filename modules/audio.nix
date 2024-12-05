{ config, pkgs, ... }:

{
  # Standard audio implementation
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = { 
      enable = true; 
      support32Bit = true; 
    };
    
    wireplumber.extraConfig = {
      "dont-switch-device-profiles"."wireplumber.settings"."bluetooth.autoswitch-to-headset-profile" = false;
    };
  };
}
