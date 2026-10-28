{
  self,
  lib,
  ...
}: let
  math = import "${self}/lib/math.nix" {inherit lib;};
  hsl = import "${self}/lib/hsl.nix" {inherit lib math;};
  inherit (hsl) hslToHex;
in rec {
  Palette = SolarizedKyoto;
  SolarizedKyoto = {
    slug = "solarized-kyoto";
    scheme = "Solarized Kyoto";
    author = "bugs";

    base00 = hslToHex 192.22 100 4.85;
    base01 = hslToHex 190.43 100 9.02;
    base02 = hslToHex 189.85 100 13.14;
    base03 = hslToHex 189.44 100 17.45;
    base04 = hslToHex 188.96 100 26.27;
    base05 = hslToHex 186.32 8.30 55.10;
    base06 = hslToHex 185.45 11.70 63.14;
    base07 = hslToHex 185.00 16.44 71.37;
    base08 = hslToHex 1.04 71.19 52.35;
    base09 = hslToHex 17.57 80.44 44.12;
    base0A = hslToHex 45.41 100 35.49;
    base0B = hslToHex 67.84 100 30;
    base0C = hslToHex 175.46 58.62 39.80;
    base0D = hslToHex 204.77 69.35 48.63;
    base0E = hslToHex 330.96 64.08 51.96;
    base0F = hslToHex 236.59 42.72 59.61;
  };
}
