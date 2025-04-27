{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  patchelf,
  zstd,
  pkgs,
  extraPkgs ? []
}:

let
  pname = "alchemy";
  version = "7.1.9.2516";
  appname = "Alchemy Viewer";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = appname;
    genericName = "Third-party Second Life Viewer";
    categories = [ "Game" "Network" "Chat" "Simulation" ];
    startupWMClass = pname;
  };

  bundledFonts = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    corefonts
    roboto
  ];

  commonLibs = with pkgs; [
    fontconfig
    freetype
    harfbuzz
    fribidi
    libjpeg
    libpng
    libxml2
    alsa-lib
    libpulseaudio
    SDL2
    mesa
    vulkan-loader
    wayland
    libxkbcommon
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    freealut
    libdecor
    xorg.libXcursor
    libcef
    systemd
    dbus
    libglvnd
  ];

in stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/AlchemyViewer/Alchemy/releases/download/${version}-beta/Alchemy_Beta_${builtins.replaceStrings [ "." ] [ "_" ] version}_x86_64.tar.zst";
    hash = "sha256-FjqDU7HskfQkZlgLhT/gMdl9YHRnaNlwvxBUYdLlock=";
  };

  nativeBuildInputs = [ makeWrapper patchelf zstd ];
  buildInputs = commonLibs ++ extraPkgs ++ bundledFonts;

  unpackPhase = ''
    zstd -d --stdout ${src} | tar xf -
    mv $(find . -maxdepth 1 -type d -name 'Alchemy_Beta_*' | head -n1) source
    export sourceRoot="$PWD/source"
  '';

  installPhase = ''
    runHook preInstall

    cd "$sourceRoot"
    mkdir -p $TMPDIR/alchemy-staging
    cp -r . $TMPDIR/alchemy-staging/
    cd $TMPDIR/alchemy-staging

    # Remove sandbox and unnecessary files (sandbox warnings are expected on NixOS)
    find . -name '*sandbox*' -delete
    find . -name 'libcef_dll_wrapper.*' -delete

    # Fontconfig: point to Nix store fonts, not /usr/share/fonts
    mkdir -p etc/fonts

cat > etc/fonts/fonts.conf <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  ${lib.concatMapStrings (pkg: ''
    <dir>${pkg}/share/fonts/truetype</dir>
    <dir>${pkg}/share/fonts/opentype</dir>
    <dir>${pkg}/share/fonts</dir>
  '') bundledFonts}
  <match target="font">
    <edit name="antialias" mode="assign"><bool>true</bool></edit>
    <edit name="hinting" mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
    <edit name="rgba" mode="assign"><const>rgb</const></edit>
    <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
  </match>
</fontconfig>
EOF

    # Symlink bundled font packages
    mkdir -p fonts
    for fontPkg in ${lib.escapeShellArgs bundledFonts}; do
      find "$fontPkg" \( -name '*.ttf' -o -name '*.otf' -o -name '*.ttc' \) -exec ln -sf {} fonts/ \;
    done

    # Symlink libraries
    mkdir -p lib
    ln -sf ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 lib/
    ln -sf ${pkgs.libcef}/lib/libcef.so lib/
    ln -sf ${pkgs.libcef}/lib/libcef.so.1 lib/

    # Install to output
    mkdir -p "$out/opt/${pname}" "$out/bin"
    cp -r . "$out/opt/${pname}/"

    # Patch ELF binaries (errors for static binaries are expected)
    find "$out/opt/${pname}" -type f -exec sh -c '
      if file -b "$1" | grep -q "ELF.*executable"; then
        patchelf \
          --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
          --set-rpath "$out/opt/${pname}/lib:${lib.makeLibraryPath buildInputs}" \
          "$1" || true
      fi
    ' _ {} \;

    # Wrap binary for runtime
    makeWrapper "$out/opt/${pname}/${pname}" "$out/bin/${pname}" \
      --set FONTCONFIG_FILE "$out/opt/${pname}/etc/fonts/fonts.conf" \
      --set QT_XKB_CONFIG_ROOT "${pkgs.xkeyboard_config}/share/X11/xkb" \
      --set QTWEBENGINE_DISABLE_SANDBOX 1 \
      --set CEF_ENABLE_SANDBOX 0 \
      --set NIXOS_OZONE_WL 1 \
      --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:$out/opt/${pname}/lib"

    # Desktop integration
    mkdir -p "$out/share/applications" "$out/share/pixmaps"
    cp "${desktopItem}/share/applications/"* "$out/share/applications/"
    ln -s "$out/opt/${pname}/${pname}_icon.png" "$out/share/pixmaps/${pname}.png"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Third-party client for Second Life";
    homepage = "https://github.com/AlchemyViewer/Alchemy";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = [ "Vixenin" ];
    mainProgram = pname;
  };
}
