# Pulled from: https://github.com/NixOS/nixpkgs/pull/374771/
# Updated to 0.7.4 with fixes

{ 
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gdk-pixbuf,
  gtk4,
  libdrm,
  vulkan-loader,
  vulkan-tools,
  coreutils,
  nix-update-script,
  hwdata,
  fuse3,
  ocl-icd,
}:

let
  rust-overlay = fetchFromGitHub {
    owner = "oxalica";
    repo = "rust-overlay";
    rev = "master";
    hash = "sha256-c7i0xJ+xFhgjO9SWHYu5dF/7lq63RPDvwKAdjc6VCE4=";
  };

  pkgs = import <nixpkgs> {
    overlays = [ (import rust-overlay) ];
    inherit (stdenv) system;
  };

  rustNightly = pkgs.rust-bin.nightly.latest.default.override {
    extensions = [ "rust-src" ];
  };

  customRustPlatform = pkgs.makeRustPlatform {
    cargo = rustNightly;
    rustc = rustNightly;
  };
in
customRustPlatform.buildRustPackage rec {
  pname = "lact";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    tag = "v${version}";
    hash = "sha256-zOvFWl78INlpCcEHiB3qZdxPNHXfUeKxfHyrO+wVNN0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-10FdXUpLL+8xN818toShccgB5NfpzrOLfEeDAX5oMFw=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    pkgs.rustPlatform.bindgenHook
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libdrm
    vulkan-loader
    vulkan-tools
    hwdata
    fuse3
    ocl-icd
  ];

  RUSTFLAGS = lib.optionalString stdenv.targetPlatform.isElf (
    lib.concatStringsSep " " [
      "-C link-arg=-Wl,-rpath,${lib.makeLibraryPath [ vulkan-loader libdrm ]}"
      "-C link-arg=-lvulkan"
      "-C link-arg=-ldrm"
    ]
  );

  checkFlags = [
    "--skip=app::pages::thermals_page::fan_curve_frame::tests::set_get_curve"
    "--skip=tests::snapshot_everything"
  ];

  postPatch = ''
    substituteInPlace lact-daemon/src/server/system.rs \
      --replace-fail 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'

    substituteInPlace res/lactd.service \
      --replace-fail ExecStart={lact,$out/bin/lact}

    # Inject a default .desktop file manually
    cat > res/io.github.lact-linux.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=LACT
      Exec=lact
      Icon=video-display
      Categories=Settings;System;
      Terminal=false
    EOF

    substituteInPlace lact-daemon/src/server/handler.rs \
      --replace-fail 'Database::read()' 'Database::read_from_file("${hwdata}/share/hwdata/pci.ids")'
  '';

  postInstall = ''
    install -Dm444 res/lactd.service -t $out/lib/systemd/system
    install -Dm444 res/io.github.lact-linux.desktop -t $out/share/applications
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ vulkan-tools ]}"
    )
  '';

  postFixup = lib.optionalString stdenv.targetPlatform.isElf ''
    patchelf $out/bin/.lact-wrapped \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader libdrm ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux GPU Configuration Tool for AMD and NVIDIA";
    homepage = "https://github.com/ilya-zlobintsev/LACT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vixenin ];
    platforms = lib.platforms.linux;
    mainProgram = "lact";
  };
}
