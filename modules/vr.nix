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

    # Install wivrn :3
    systemd.services.flatpak-wivrn-install = {
        wantedBy = [ "multi-user.target" ];
        after = [ "flatpak-repo.service" ];
        path = [ pkgs.flatpak ];
        script = ''
            flatpak install -y flathub io.github.wivrn.wivrn
        '';
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = false;
        };
    };

    # Wivrn config
    system.activationScripts.setupWivrnConfig = let
    wivrnConfig = builtins.toJSON {
        "scale" = 0.4;
        "bitrate" = 50000000;
        "encoders" = [
            {
                "encoder" = "nvenc";
                "codec" = "h264";
                "width" = 0.5;
                "height" = 1.0;
                "offset_x" = 0.0;
                "offset_y" = 0.0;
            }
            {
                "encoder" = "nvenc";
                "codec" = "h264";
                "width" = 0.5;
                "height" = 1.0;
                "offset_x" = 0.5;
                "offset_y" = 0.0;
            }
        ];
        "application" = "wlx-overlay-s";
        "tcp_only" = true;
    };
    in ''
        for user in /home/*; do
            if [ -d "$user" ]; then
                # Create Wivrn config directory
                mkdir -p "$user/.var/app/io.github.wivrn.wivrn/config/wivrn"

                # Write the Wivrn configuration
                echo '${wivrnConfig}' > "$user/.var/app/io.github.wivrn.wivrn/config/wivrn/config.json"

                # Set ownership to the user
                chown $(basename "$user") "$user/.var/app/io.github.wivrn.wivrn/config/wivrn/config.json"
            fi
        done
    '';

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
