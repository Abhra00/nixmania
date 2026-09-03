{
  stdenvNoCC,
  monofonts-src,
}:
stdenvNoCC.mkDerivation {
  pname = "monofonts";
  version = "1.0";
  src = monofonts-src;
  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    runHook preInstall
    install -Dm644 CartographCF/*.ttf -t $out/share/fonts/truetype/CartographCF
    install -Dm644 Hasklug/*.otf -t $out/share/fonts/opentype/Hasklug
    runHook postInstall
  '';
}
