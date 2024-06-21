{ callPackage
, lib
, jre8_headless
, jre_headless
}:
let
  loader_versions = lib.importJSON ./lock_launcher.json;
  library_versions = lib.importJSON ./lock_libraries.json;
  game_versions = lib.importJSON ./lock_game.json;

  # Older Minecraft versions that were written for Java 8, required Java 8.
  # Mojang has since rewritten a lot of their codebase so that Java versions
  # are no longer as important for stability as they used to be. Meaning we can
  # target latest the latest JDK for all newer versions of Minecraft.
  # TODO: Assert that jre_headless >= java version
  getJavaVersion = v: if v == 8 then jre8_headless else jre_headless;

  packages =
    mapAttrsToList
      (version: builds:
        sortBy "version" versionOlder (mapAttrsToList
          (buildNumber: value:
            callPackage ./derivation.nix {
              inherit (value) installerSha1 installerUrl manifestUrl manifestSha1;
              version = "${version}-${buildNumber}";
            })
          builds))
      versions;
in
lib.recurseIntoAttrs (
  packages
)
