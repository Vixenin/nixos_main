{ config, pkgs, ... }:

{
    # Avahi for vr | wivrn
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
                    "bitrate": 80000000,
                    "encoders": [
                        {
                            "encoder": "nvenc",
                            "codec": "h264",
                            "width": 0.5,
                            "height": 0.25,
                            "offset_x": 0.0,
                            "offset_y": 0.0,
                            "group": 0
                        },
                        {
                            "encoder": "nvenc",
                            "codec": "h264",
                            "width": 0.5,
                            "height": 0.75,
                            "offset_x": 0.0,
                            "offset_y": 0.25,
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

    # Install wlx-overlay-s
    environment.systemPackages = [
        pkgs.wlx-overlay-s
    ];

    # Reverse adb tether service for wivrn
    systemd.services.adb-reverse = {
        description = "Maintain ADB Reverse for Wivrn";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        path = [ pkgs.android-tools ];
        serviceConfig = {
            ExecStart = "${pkgs.android-tools}/bin/adb reverse tcp:9757 tcp:9757";
            Restart = "always";
            RestartSec = 5;
            StandardOutput = "journal";
            StandardError = "journal";
        };
    };

    # Wivrn launch Service (manual trigger)
    systemd.services.wivrn-launch = {
        description = "Launch Wivrn on Android Device";
        path = [ pkgs.android-tools ];
        serviceConfig = {
            ExecStart = "${pkgs.android-tools}/bin/adb shell am start -a android.intent.action.VIEW -d 'wivrn+tcp://localhost' org.meumeu.wivrn.github";
            StandardOutput = "journal";
            StandardError = "journal";
        };
    };
}
