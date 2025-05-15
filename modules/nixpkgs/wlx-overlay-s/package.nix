# Pulled from: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/wl/wlx-overlay-s/package.nix#L78
# Fixes for &mut
{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  fontconfig,
  lib,
  libGL,
  libX11,
  libXext,
  libXrandr,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  openvr,
  openxr-loader,
  pipewire,
  pkg-config,
  pulseaudio,
  rustPlatform,
  shaderc,
  stdenv,
  testers,
  wayland,
  wlx-overlay-s,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlx-overlay-s";
  version = "25.4.2";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlx-overlay-s";
    rev = "v${version}";
    hash = "sha256-lWUfhiHRxu72p9ZG2f2fZH6WZECm/fOKcK05MLZV+MI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-em5sWSty2/pZp2jTwBnLUIBgPOcoMpwELwj984XYf+k=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    fontconfig
    libGL
    libX11
    libXext
    libXrandr
    libxkbcommon
    openvr
    openxr-loader
    pipewire
    wayland
  ];

  env.SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  postPatch = ''
    substituteAllInPlace src/res/watch.yaml \
      --replace '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'

    # Fix for &mut in const fn
    find src -type f -name '*.rs' -exec sed -i -E \
      's/(^[ \t]*)(#[^\n]*\n)?([ \t]*)(pub[ \t]+)?(unsafe[ \t]+)?const fn ([a-zA-Z0-9_]+)\s*\(&mut self/\1\2\3\4\5fn \6(\&mut self/g' {} \;

    # TODO: src/res/keyboard.yaml references 'whisper_stt'
  '';

  passthru = {
    tests.testVersion = testers.testVersion { package = wlx-overlay-s; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland/X11 desktop overlay for SteamVR and OpenXR, Vulkan edition";
    homepage = "https://github.com/galister/wlx-overlay-s";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Vixenin ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "wlx-overlay-s";
  };
}
