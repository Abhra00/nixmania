{
  lib,
  math,
  hsl,
}: let
  inherit (math) mod;

  clamp = lo: hi: x:
    if x < lo
    then lo
    else if x > hi
    then hi
    else x;

  shadeDiffs = {
    yellow = {
      "50" = {
        dh = 2;
        ds = 0;
        dl = 56;
      };
      "100" = {
        dh = 2;
        ds = 0;
        dl = 45;
      };
      "200" = {
        dh = 1;
        ds = 0;
        dl = 30;
      };
      "300" = {
        dh = 0;
        ds = 0;
        dl = 15;
      };
      "400" = {
        dh = 0;
        ds = 0;
        dl = 8;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 0;
        ds = 0;
        dl = -7;
      };
      "700" = {
        dh = 0;
        ds = 0;
        dl = -15;
      };
      "800" = {
        dh = 0;
        ds = 0;
        dl = -20;
      };
      "900" = {
        dh = 1;
        ds = 0;
        dl = -25;
      };
      "950" = {
        dh = 0.5;
        ds = 0;
        dl = -29.31;
      };
    };
    orange = {
      "50" = {
        dh = -0.5;
        ds = 20;
        dl = 41.9;
      };
      "100" = {
        dh = -1;
        ds = 20;
        dl = 26;
      };
      "200" = {
        dh = -1;
        ds = 17;
        dl = 17;
      };
      "300" = {
        dh = -1;
        ds = 14;
        dl = 7;
      };
      "400" = {
        dh = 0;
        ds = 7;
        dl = 4;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 0;
        ds = 0;
        dl = -4;
      };
      "700" = {
        dh = 0;
        ds = 1;
        dl = -9;
      };
      "800" = {
        dh = 0;
        ds = 0;
        dl = -16;
      };
      "900" = {
        dh = 0;
        ds = 0;
        dl = -24;
      };
      "950" = {
        dh = -0.1;
        ds = 10.5;
        dl = -31.6;
      };
    };
    red = {
      "50" = {
        dh = 0.3;
        ds = 29;
        dl = 39;
      };
      "100" = {
        dh = 0;
        ds = 29;
        dl = 28;
      };
      "200" = {
        dh = 0;
        ds = 24;
        dl = 20;
      };
      "300" = {
        dh = 0;
        ds = 19;
        dl = 12;
      };
      "400" = {
        dh = 0;
        ds = 9;
        dl = 6;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 0;
        ds = 0;
        dl = -5;
      };
      "700" = {
        dh = 0;
        ds = 0;
        dl = -10;
      };
      "800" = {
        dh = 0;
        ds = 0;
        dl = -21;
      };
      "900" = {
        dh = 0;
        ds = 0;
        dl = -32;
      };
      "950" = {
        dh = 0.18;
        ds = 12.6;
        dl = -40;
      };
    };
    magenta = {
      "50" = {
        dh = 0;
        ds = 36;
        dl = 34.3;
      };
      "100" = {
        dh = 0;
        ds = 36;
        dl = 21;
      };
      "200" = {
        dh = 0;
        ds = 29;
        dl = 16;
      };
      "300" = {
        dh = 0;
        ds = 22;
        dl = 12;
      };
      "400" = {
        dh = 0;
        ds = 11;
        dl = 6;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 0;
        ds = 0;
        dl = -5;
      };
      "700" = {
        dh = 0;
        ds = 0;
        dl = -10;
      };
      "800" = {
        dh = 0;
        ds = 0;
        dl = -21;
      };
      "900" = {
        dh = 0;
        ds = 1;
        dl = -32;
      };
      "950" = {
        dh = 1;
        ds = 13.8;
        dl = -39.6;
      };
    };
    violet = {
      "50" = {
        dh = 0;
        ds = 57;
        dl = 35.9;
      };
      "100" = {
        dh = -1;
        ds = 57;
        dl = 30;
      };
      "200" = {
        dh = 0;
        ds = 42;
        dl = 24;
      };
      "300" = {
        dh = 0;
        ds = 26;
        dl = 17;
      };
      "400" = {
        dh = 0;
        ds = 13;
        dl = 8;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 0;
        ds = 0;
        dl = -5;
      };
      "700" = {
        dh = 0;
        ds = 0;
        dl = -10;
      };
      "800" = {
        dh = 0;
        ds = 0;
        dl = -23;
      };
      "900" = {
        dh = 0;
        ds = -1;
        dl = -35;
      };
      "950" = {
        dh = 0;
        ds = 18.1;
        dl = -45.9;
      };
    };
    blue = {
      "50" = {
        dh = 1;
        ds = 31;
        dl = 43.2;
      };
      "100" = {
        dh = 0;
        ds = 31;
        dl = 34;
      };
      "200" = {
        dh = 0;
        ds = 26;
        dl = 24;
      };
      "300" = {
        dh = 0;
        ds = 21;
        dl = 13;
      };
      "400" = {
        dh = 0;
        ds = 11;
        dl = 6;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 0;
        ds = 1;
        dl = -7;
      };
      "700" = {
        dh = 0;
        ds = 1;
        dl = -14;
      };
      "800" = {
        dh = 0;
        ds = 1;
        dl = -21;
      };
      "900" = {
        dh = 0;
        ds = 0;
        dl = -29;
      };
      "950" = {
        dh = 0;
        ds = 12;
        dl = -36.6;
      };
    };
    cyan = {
      "50" = {
        dh = 1;
        ds = 41;
        dl = 54.3;
      };
      "100" = {
        dh = 1;
        ds = 41;
        dl = 46;
      };
      "200" = {
        dh = 0;
        ds = 33;
        dl = 30;
      };
      "300" = {
        dh = 0;
        ds = 26;
        dl = 15;
      };
      "400" = {
        dh = 0;
        ds = 13;
        dl = 8;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 3;
        ds = 0;
        dl = -7;
      };
      "700" = {
        dh = 7;
        ds = 0;
        dl = -15;
      };
      "800" = {
        dh = 7;
        ds = -1;
        dl = -20;
      };
      "900" = {
        dh = 8;
        ds = -1;
        dl = -25;
      };
      "950" = {
        dh = 7;
        ds = 16;
        dl = -32.16;
      };
    };
    green = {
      "50" = {
        dh = 22;
        ds = 0;
        dl = 62.2;
      };
      "100" = {
        dh = 22;
        ds = 0;
        dl = 54;
      };
      "200" = {
        dh = 15;
        ds = 0;
        dl = 36;
      };
      "300" = {
        dh = 8;
        ds = 0;
        dl = 19;
      };
      "400" = {
        dh = 4;
        ds = 0;
        dl = 10;
      };
      "500" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "600" = {
        dh = 0;
        ds = 0;
        dl = -5;
      };
      "700" = {
        dh = 0;
        ds = 0;
        dl = -10;
      };
      "800" = {
        dh = 0;
        ds = 0;
        dl = -15;
      };
      "900" = {
        dh = 0;
        ds = 0;
        dl = -20;
      };
      "950" = {
        dh = 0.3;
        ds = 0;
        dl = -24.31;
      };
    };
    bg = {
      "00" = {
        dh = 4;
        ds = -87;
        dl = 40;
      };
      "01" = {
        dh = 2;
        ds = -86;
        dl = 35;
      };
      "02" = {
        dh = 0;
        ds = -19;
        dl = 9;
      };
      "03" = {
        dh = 0;
        ds = 0;
        dl = 6;
      };
      "04" = {
        dh = 0;
        ds = 0;
        dl = 0;
      };
      "bg_highlight" = {
        dh = 0;
        ds = 0;
        dl = 6;
      };
    };
    fg = {
      "0" = {
        dh = 0;
        ds = 0;
        dl = 10;
      };
      "1" = {
        dh = -6;
        ds = -1;
        dl = 15;
      };
      "2" = {
        dh = -140;
        ds = 34;
        dl = 33;
      };
      "3" = {
        dh = -142;
        ds = 79;
        dl = 39;
      };
      "4" = {
        dh = -186;
        ds = -8;
        dl = 45;
      };
    };
  };

  # Returns "#RRGGBB" (hashtag included, per hsl.hslToHex). Strip it at the
  # call site (e.g. `lib.removePrefix "#"`) if you need a bare hex string.
  mkShadeSteps = baseHex: diffs: let
    base = hsl.hexToHsl baseHex;
    step = d: let
      h = mod (base.h + d.dh) 360;
      s = clamp 0 100 (base.s + d.ds);
      l = clamp 0 100 (base.l + d.dl);
    in
      hsl.hslToHex h s l;
  in
    builtins.mapAttrs (name: d: step d) diffs;

  mkShadeRamp = colorName: baseHex: let
    steps = mkShadeSteps baseHex shadeDiffs.${colorName};
    prefixed = builtins.listToAttrs (lib.mapAttrsToList (name: v: {
        name = "${colorName}${name}";
        value = v;
      })
      steps);
  in
    prefixed // {${colorName} = baseHex;};

  mkShadeRamps = accents:
    builtins.foldl' (acc: name: acc // mkShadeRamp name accents.${name}) {} (builtins.attrNames accents);
in {
  inherit clamp shadeDiffs mkShadeSteps mkShadeRamp mkShadeRamps;
}
