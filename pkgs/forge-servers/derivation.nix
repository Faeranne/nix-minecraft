{ lib, stdenvNoCC, fetchurl, nixosTests, jre_headless, version, manifestUrl, manifestSha1, installerUrl, installerSha1 }:
stdenvNoCC.mkDerivation {
  pname = "minecraft-server-forge";
  inherit version;

  src = fetchurl { 
    url = installerUrl;
    sha1 = installerSha1;
  };

  preferLocalBuild = true;

  patchPhase = ''
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/server.jar

    chmod +x $out/bin/minecraft-server
  '';

  dontUnpack = true;

  passthru = {
    updateScript = ./update.py;
  };

  meta = with lib; {
    description = "Minecraft Server";
    homepage = "https://minecraft.net";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "minecraft-server";
  };
}
