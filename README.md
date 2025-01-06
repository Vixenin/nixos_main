# Nixos Main Rig
My main nixos config :)
--------------------
Gnome Wayland
* Steam machine 🎮
* VR Support (Pico 4 with WiVRn) 🥽
* Nvidia, Wayland & Gaming tweaks and fixes 🔧

For Steam:
- Use the launch option: PROTON_USE_WINED3D=0 PROTON_ENABLE_NVAPI=1 PROTON_USE_DXVK=1 gamemoderun mangohud %command%

For VR:
- You must install WiVRn from either the Flathub or https://github.com/WiVRn/WiVRn
- If the app has issues with Monado Vulkan Layers than install the v0.21.1 from the github

For Discord on Wayland with audio support for screen share:
- flatpak update --commit=3d3433b58b180cfb9ac24b3a30b11195f6fddf7eb67da923bb577062ed59ab55 com.discordapp.DiscordCanary
- and in ~/.config/discordcanary/settings.json 
"SKIP_HOST_UPDATE": true

![image](https://github.com/user-attachments/assets/d9972738-b73f-437b-bd12-4dc08cc4c5c0)
