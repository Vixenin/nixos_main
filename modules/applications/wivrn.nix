{ config, pkgs, ... }:

{
    environment.systemPackages = [
        pkgs.android-tools # Adb for reverse tcp | wivrn
    ];

    # Avahi service for vr | wivrn
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
            enable = true;
            userServices = true;
        };
    };

    # Wivrn config
    system.userActivationScripts.setupWivrnConfig = {
        text = ''
      wivrnConfig=$(cat <<EOF
{
  "application": [
    "wlx-overlay-s"
  ],
  "bitrate": 150000000,
  "encoders": [
    {
      "codec": "h264",
      "encoder": "nvenc",
      "height": 1.0,
      "offset_x": 0.0,
      "offset_y": 0.0,
      "width": 1.0
    }
  ],
  "openvr-compat-path": "xrizer",
  "scale": 0.5,
  "tcp_only": true
}
EOF
      )

            mkdir -p ~/.var/app/io.github.wivrn.wivrn/config/wivrn
            echo "$wivrnConfig" > ~/.var/app/io.github.wivrn.wivrn/config/wivrn/config.json
        '';
    };
}
