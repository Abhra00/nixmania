# lib/hsl.nix
{math, ...}: let
  inherit (math) int mod;

  hexDigits = "0123456789abcdef";
  hexDigit = n: builtins.substring n 1 hexDigits;
  toHex2 = n: let i = int n; in "${hexDigit (i / 16)}${hexDigit (mod i 16)}";

  hue2rgb = p: q: t0: let
    t =
      if t0 < 0
      then t0 + 1
      else if t0 > 1
      then t0 - 1
      else t0;
  in
    if t < 1.0 / 6
    then p + (q - p) * 6 * t
    else if t < 1.0 / 2
    then q
    else if t < 2.0 / 3
    then p + (q - p) * (2.0 / 3 - t) * 6
    else p;
in rec {
  hslToRgb = h: s: l:
    if s == 0
    then {
      r = l;
      g = l;
      b = l;
    }
    else let
      q =
        if l < 0.5
        then l * (1 + s)
        else l + s - l * s;
      p = 2 * l - q;
    in {
      r = hue2rgb p q (h + 1.0 / 3);
      g = hue2rgb p q h;
      b = hue2rgb p q (h - 1.0 / 3);
    };

  hslToHex = h: s: l: let
    rgb = hslToRgb (h * 1.0 / 360) (s * 1.0 / 100) (l * 1.0 / 100);
    r = int (rgb.r * 255);
    g = int (rgb.g * 255);
    b = int (rgb.b * 255);
  in "#${toHex2 r}${toHex2 g}${toHex2 b}";
}
