{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  xorg,
  gtk2,
  sqlite,
  openal,
  cairo,
  libGLU,
  SDL2,
  freealut,
  libglvnd,
  pipewire,
  libpulseaudio,
  dotnet-runtime_8,
}:

stdenv.mkDerivation rec {
  pname = "vintagestory";
  version = "1.20.1";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
    hash = "sha256-FXguajZ/sKDbUEwkwnjBJcpz5jcM1rrVzqTLXn6TS1M=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [ dotnet-runtime_8 ];

  runtimeLibs = lib.makeLibraryPath (
    [
      gtk2
      sqlite
      openal
      cairo
      libGLU
      SDL2
      freealut
      libglvnd
      pipewire
      libpulseaudio
    ]
    ++ (with xorg; [
      libX11
      libXi
      libXcursor
    ])
  );

  desktopItems = [
    (makeDesktopItem {
      name = "vintagestory";
      desktopName = "Vintage Story";
      exec = "vintagestory";
      icon = "vintagestory";
      comment = "Innovate and explore in a sandbox world";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/vintagestory $out/bin $out/share/pixmaps $out/share/fonts/truetype
    cp -r * $out/share/vintagestory
    cp $out/share/vintagestory/assets/gameicon.xpm $out/share/pixmaps/vintagestory.xpm
    cp $out/share/vintagestory/assets/game/fonts/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  preFixup = ''
    # Wrapper for the Vintage Story client
    makeWrapper ${dotnet-runtime_8}/bin/dotnet $out/bin/vintagestory \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --set DOTNET_ROOT ${dotnet-runtime_8}/share/dotnet \
      --set DOTNET_ROLL_FORWARD Major \
      --add-flags $out/share/vintagestory/Vintagestory.dll

    # Wrapper for the Vintage Story server
    makeWrapper ${dotnet-runtime_8}/bin/dotnet $out/bin/vintagestory-server \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --set DOTNET_ROOT ${dotnet-runtime_8}/share/dotnet \
      --set DOTNET_ROLL_FORWARD Major \
      --add-flags $out/share/vintagestory/VintagestoryServer.dll

    # Normalize file names for case-insensitive matching
    find "$out/share/vintagestory/assets/" -not -path "*/fonts/*" -regex ".*/.*[A-Z].*" | while read -r file; do
      local filename="$(basename -- "$file")"
      ln -sf "$filename" "''${file%/*}"/"''${filename,,}"
    done
  '';

  meta = with lib; {
    description = "In-development indie sandbox game about innovation and exploration";
    homepage = "https://www.vintagestory.at/";
    license = licenses.unfree;
    maintainers = with maintainers; [
      vixenin
    ];
  };
}
