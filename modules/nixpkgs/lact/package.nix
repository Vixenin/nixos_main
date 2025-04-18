# Pulled from: https://github.com/NixOS/nixpkgs/pull/374771/
# Updated to 0.7.3 with default icon fix

{
  lib,
  rustPlatform,
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
}:

rustPlatform.buildRustPackage rec {
  pname = "lact";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    tag = "v${version}";
    hash = "sha256-R8VEAk+CzJCxPzJohsbL/XXH1GMzGI2W92sVJ2evqXs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SH7jmXDvGYO9S5ogYEYB8dYCF3iz9GWDYGcZUaKpWDQ=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libdrm
    vulkan-loader
    vulkan-tools
    hwdata
    fuse3
  ];

  RUSTFLAGS = lib.optionalString stdenv.targetPlatform.isElf (
    lib.concatStringsSep " " [
      "-C link-arg=-Wl,-rpath,${
        lib.makeLibraryPath [
          vulkan-loader
          libdrm
        ]
      }"
      "-C link-arg=-Wl,--add-needed,${vulkan-loader}/lib/libvulkan.so"
      "-C link-arg=-Wl,--add-needed,${libdrm}/lib/libdrm.so"
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

    substituteInPlace \
      lact-daemon/src/server/handler.rs \
      lact-daemon/src/tests/mod.rs \
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
    --add-needed libvulkan.so \
    --add-needed libdrm.so \
    --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        libdrm
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux GPU Configuration Tool for AMD and NVIDIA";
    homepage = "https://github.com/ilya-zlobintsev/LACT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vixenin
    ];
    platforms = lib.platforms.linux;
    mainProgram = "lact";
  };
}
