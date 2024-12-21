{ config, pkgs, ... }:

{
    environment.systemPackages = [
        pkgs.monado-vulkan-layers # Monado vulkan layers for vr | wivrn
        pkgs.wlx-overlay-s # Overlay for vr | wivrn 
        pkgs.android-tools # Adb for reverse tcp | wivrn
    ];

    # Monado vulkan layers for vr | wivrn (https://github.com/PassiveLemon/lemonake/issues/9#issuecomment-2525188053)
    hardware.graphics.extraPackages = with pkgs; [monado-vulkan-layers];

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
                    "bitrate": 50000000,
                    "encoders": [
                        {
                            "encoder": "nvenc",
                            "codec": "h264",
                            "width": 0.5,
                            "height": 1.0,
                            "offset_x": 0.0,
                            "offset_y": 0.0,
                            "group": 0
                        },
                        {
                            "encoder": "nvenc",
                            "codec": "h264",
                            "width": 0.5,
                            "height": 1.0,
                            "offset_x": 0.5,
                            "offset_y": 0.0,
                            "group": 0
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
