{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [mangohud];

  # Config
  system.userActivationScripts.setupMangoHud = {
    text = ''
      mangohudSettings=$(cat <<EOF
        fps_limit=162
        fps_only=1
        font_size=20
        position=top-left
        text_color=FF69B4
        background_alpha=0
  EOF
      )

      # Mangohud setup
      mkdir -p ~/.config/MangoHud
      echo "$mangohudSettings" > ~/.config/MangoHud/MangoHud.conf
    '';
  };
}