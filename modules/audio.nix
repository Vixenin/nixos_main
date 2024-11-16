{ config, pkgs, ... }:

{
  # Standard audio implementation
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = { 
      enable = true; 
      support32Bit = true; 
    };

    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Alsa state persistence
  sound.enable = true;

  # Alsa default sound card
  environment.etc."asound.conf".text = ''
    defaults.pcm.card 1
    defaults.ctl.card 1
  '';
}
