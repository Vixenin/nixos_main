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
                    "scale": 0.4,
                    "bitrate": 15000000,
                    "encoders": [
                        {
                            "encoder": "nvenc",
                            "codec": "h264",
                            "width": 1.0,
                            "height": 1.0,
                            "offset_x": 0.0,
                            "offset_y": 0.0
                        }
                    ],
                    "application": "wlx-overlay-s",
                    "tcp_only": true
                }
        EOF
            )

            mkdir -p ~/.var/app/io.github.wivrn.wivrn/config/wivrn
            echo "$wivrnConfig" > ~/.var/app/io.github.wivrn.wivrn/config/wivrn/config.json
        '';
    };
}
