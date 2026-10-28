{
  lib,
  math,
}: let
  inherit (math) round mod;

  hexAlphabet = "0123456789abcdef";
  hexChars = lib.stringToCharacters hexAlphabet;

  hexCharAt = index: builtins.substring index 1 hexAlphabet;

  hexCharValue = builtins.listToAttrs (lib.imap0 (value: char: {
      name = char;
      inherit value;
    })
    hexChars);

  byteToHex = byte: "${hexCharAt (byte / 16)}${hexCharAt (mod byte 16)}";

  parseHexByte = pair: let
    lower = lib.toLower pair;
  in
    hexCharValue.${builtins.substring 0 1 lower}
    * 16
    + hexCharValue.${builtins.substring 1 1 lower};

  hexToUnitRgb = hex: let
    digits = lib.removePrefix "#" hex;
    channel = offset: parseHexByte (builtins.substring offset 2 digits) / 255.0;
  in [(channel 0) (channel 2) (channel 4)];

  hueToChannel = p: q: t0: let
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
  inherit byteToHex hexToUnitRgb;

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
      r = hueToChannel p q (h + 1.0 / 3);
      g = hueToChannel p q h;
      b = hueToChannel p q (h - 1.0 / 3);
    };

  hslToHex = h: s: l: let
    rgb = hslToRgb (h * 1.0 / 360) (s * 1.0 / 100) (l * 1.0 / 100);
    r = round (rgb.r * 255);
    g = round (rgb.g * 255);
    b = round (rgb.b * 255);
  in "#${byteToHex r}${byteToHex g}${byteToHex b}";

  hexToHsl = hex: let
    rgb = hexToUnitRgb hex;
    r = builtins.elemAt rgb 0;
    g = builtins.elemAt rgb 1;
    b = builtins.elemAt rgb 2;
    maxc = lib.max r (lib.max g b);
    minc = lib.min r (lib.min g b);
    l = (maxc + minc) / 2;
    delta = maxc - minc;
    s =
      if delta == 0
      then 0
      else if l > 0.5
      then delta / (2 - maxc - minc)
      else delta / (maxc + minc);
    hueSector =
      if delta == 0
      then 0
      else if maxc == r
      then
        (
          if g < b
          then (g - b) / delta + 6
          else (g - b) / delta
        )
      else if maxc == g
      then (b - r) / delta + 2
      else (r - g) / delta + 4;
  in {
    h = hueSector * 60;
    s = s * 100;
    l = l * 100;
  };
}
