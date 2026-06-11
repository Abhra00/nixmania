# lib/hsluv.nix
{
  lib,
  math,
}: let
  # RGB <-> XYZ transformation matrices
  m = [
    [3.240969941904521 (-1.537383177570093) (-0.498610760293)]
    [(-0.96924363628087) 1.87596750150772 0.041555057407175]
    [0.055630079696993 (-0.20397695888897) 1.056971514242878]
  ];
  minv = [
    [0.41239079926595 0.35758433938387 0.18048078840183]
    [0.21263900587151 0.71516867876775 0.072192315360733]
    [0.019330818715591 0.11919477979462 0.95053215224966]
  ];

  refY = 1.0;
  refU = 0.19783000664283;
  refV = 0.46831999493879;
  kappa = 903.2962962;
  eps = 0.0088564516;

  # helpers
  dotProduct = a: b:
    (builtins.elemAt a 0)
    * (builtins.elemAt b 0)
    + (builtins.elemAt a 1) * (builtins.elemAt b 1)
    + (builtins.elemAt a 2) * (builtins.elemAt b 2);

  fromLinear = c:
    if c <= 0.0031308
    then 12.92 * c
    else 1.055 * (math.pow c 0.4166666666666667) - 0.055;

  toLinear = c:
    if c > 0.04045
    then math.pow ((c + 0.055) / 1.055) 2.4
    else c / 12.92;

  yToL = Y:
    if Y <= eps
    then Y / refY * kappa
    else 116.0 * (math.pow (Y / refY) 0.3333333333333333) - 16.0;

  lToY = L:
    if L <= 8.0
    then refY * L / kappa
    else refY * (math.pow ((L + 16.0) / 116.0) 3.0);

  getBounds = l: let
    sub1 = math.pow (l + 16.0) 3.0 / 1560896.0;
    sub2 =
      if sub1 > eps
      then sub1
      else l / kappa;
    rows = lib.range 0 2;
    mkLines = i: let
      row = builtins.elemAt m i;
      m1 = builtins.elemAt row 0;
      m2 = builtins.elemAt row 1;
      m3 = builtins.elemAt row 2;
      mkLine = t: let
        top1 = (284517.0 * m1 - 94839.0 * m3) * sub2;
        top2 =
          (838422.0 * m3 + 769860.0 * m2 + 731718.0 * m1)
          * l
          * sub2
          - 769860.0 * t * l;
        bottom = (632260.0 * m3 - 126452.0 * m2) * sub2 + 126452.0 * t;
      in {
        slope = top1 / bottom;
        intercept = top2 / bottom;
      };
    in [(mkLine 0) (mkLine 1)];
  in
    builtins.concatLists (map mkLines rows);

  distanceFromOrigin = line:
    (math.abs line.intercept) / (math.sqrt (line.slope * line.slope + 1.0));

  rayLength = theta: line:
    line.intercept / (math.sin theta - line.slope * math.cos theta);

  maxChromaForL = l: let
    bounds = getBounds l;
    lengths = map distanceFromOrigin bounds;
    positives = builtins.filter (x: x >= 0.0) lengths;
  in
    builtins.foldl' (a: b:
      if b < a
      then b
      else a)
    1.7976931348623157e+308
    positives;

  maxChromaForLH = l: h: let
    hrad = h / 360.0 * math.pi * 2.0;
    bounds = getBounds l;
    lengths = map (rayLength hrad) bounds;
    positives = builtins.filter (x: x >= 0.0) lengths;
  in
    builtins.foldl' (a: b:
      if b < a
      then b
      else a)
    1.7976931348623157e+308
    positives;

  # hex parsing
  hexChars = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
  };
  hexDigitList = ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f"];

  hexToDec = h:
    hexChars.${builtins.substring 0 1 h}
    * 16
    + hexChars.${builtins.substring 1 1 h};

  decToHex = n: let
    c = let
      x = builtins.floor n;
    in
      if x < 0
      then 0
      else if x > 255
      then 255
      else x;
  in
    builtins.elemAt hexDigitList (c / 16)
    + builtins.elemAt hexDigitList (math.mod c 16);

  hexToRGB = hex: let
    h = lib.removePrefix "#" (lib.toLower hex);
  in [
    (hexToDec (builtins.substring 0 2 h) / 255.0)
    (hexToDec (builtins.substring 2 2 h) / 255.0)
    (hexToDec (builtins.substring 4 2 h) / 255.0)
  ];

  rgbToHex = rgb:
    decToHex (builtins.elemAt rgb 0 * 255.0)
    + decToHex (builtins.elemAt rgb 1 * 255.0)
    + decToHex (builtins.elemAt rgb 2 * 255.0);

  # pipeline stages
  xyzToRGB = xyz: map (row: fromLinear (dotProduct row xyz)) m;

  rgbToXYZ = rgb: let
    linear = map toLinear rgb;
  in
    map (row: dotProduct row linear) minv;

  xyzToLuv = xyz: let
    X = builtins.elemAt xyz 0;
    Y = builtins.elemAt xyz 1;
    Z = builtins.elemAt xyz 2;
    d = X + 15.0 * Y + 3.0 * Z;
    varU =
      if d != 0.0
      then 4.0 * X / d
      else 0.0;
    varV =
      if d != 0.0
      then 9.0 * Y / d
      else 0.0;
    L = yToL Y;
  in
    if L == 0.0
    then [0.0 0.0 0.0]
    else [L (13.0 * L * (varU - refU)) (13.0 * L * (varV - refV))];

  luvToXYZ = luv: let
    L = builtins.elemAt luv 0;
    U = builtins.elemAt luv 1;
    V = builtins.elemAt luv 2;
    varU = U / (13.0 * L) + refU;
    varV = V / (13.0 * L) + refV;
    Y = lToY L;
    X = 0.0 - (9.0 * Y * varU) / (((varU - 4.0) * varV) - varU * varV);
    Z = (9.0 * Y - 15.0 * varV * Y - varV * X) / (3.0 * varV);
  in
    if L == 0.0
    then [0.0 0.0 0.0]
    else [X Y Z];

  luvToLCH = luv: let
    L = builtins.elemAt luv 0;
    U = builtins.elemAt luv 1;
    V = builtins.elemAt luv 2;
    C = math.sqrt (U * U + V * V);
    H =
      if C < 0.00000001
      then 0.0
      else let
        h = math.atan2 V U * 180.0 / math.pi;
      in
        if h < 0.0
        then 360.0 + h
        else h;
  in [L C H];

  lchToLuv = lch: let
    L = builtins.elemAt lch 0;
    C = builtins.elemAt lch 1;
    Hrad = builtins.elemAt lch 2 / 360.0 * 2.0 * math.pi;
  in [L (math.cos Hrad * C) (math.sin Hrad * C)];

  hsluvToLCH = hsl: let
    H = builtins.elemAt hsl 0;
    S = builtins.elemAt hsl 1;
    L = builtins.elemAt hsl 2;
  in
    if L > 99.9999999
    then [100.0 0.0 H]
    else if L < 0.00000001
    then [0.0 0.0 H]
    else [L (maxChromaForLH L H / 100.0 * S) H];

  lchToHSLuv = lch: let
    L = builtins.elemAt lch 0;
    C = builtins.elemAt lch 1;
    H = builtins.elemAt lch 2;
    maxC = maxChromaForLH L H;
  in
    if L > 99.9999999
    then [H 0.0 100.0]
    else if L < 0.00000001
    then [H 0.0 0.0]
    else [H (C / maxC * 100.0) L];

  lchToRGB = lch: xyzToRGB (luvToXYZ (lchToLuv lch));
  rgbToLCH = rgb: luvToLCH (xyzToLuv (rgbToXYZ rgb));
in rec {
  # hex string (with or without #) → [ H S L ] (HSLuv)
  hexToHSLuv = hex: lchToHSLuv (rgbToLCH (hexToRGB hex));

  # [ H S L ] → hex string (no #)
  hsluvToHex = hsl: rgbToHex (lchToRGB (hsluvToLCH hsl));

  # Lighten a hex color by adjusting L upward. amount 0.0–1.0
  lighten = hex: amount: let
    hsl = hexToHSLuv hex;
    L = builtins.elemAt hsl 2;
  in
    hsluvToHex [
      (builtins.elemAt hsl 0)
      (builtins.elemAt hsl 1)
      (let
        x = L + amount * (100.0 - L);
      in
        if x < 0.0
        then 0.0
        else if x > 100.0
        then 100.0
        else x)
    ];

  # Darken a hex color by adjusting L downward. amount 0.0–1.0
  darken = hex: amount: let
    hsl = hexToHSLuv hex;
    L = builtins.elemAt hsl 2;
  in
    hsluvToHex [
      (builtins.elemAt hsl 0)
      (builtins.elemAt hsl 1)
      (let
        x = L - amount * L;
      in
        if x < 0.0
        then 0.0
        else if x > 100.0
        then 100.0
        else x)
    ];

  # Saturate / desaturate. amount positive = more saturated, negative = less.
  saturate = hex: amount: let
    hsl = hexToHSLuv hex;
    S = builtins.elemAt hsl 1;
  in
    hsluvToHex [
      (builtins.elemAt hsl 0)
      (let
        x = S + amount * 100.0;
      in
        if x < 0.0
        then 0.0
        else if x > 100.0
        then 100.0
        else x)
      (builtins.elemAt hsl 2)
    ];

  # Linear mix between two hex colors in HSLuv space. t 0.0–1.0
  mix = hexA: hexB: t: let
    a = hexToHSLuv hexA;
    b = hexToHSLuv hexB;
    lerp = i: builtins.elemAt a i + (builtins.elemAt b i - builtins.elemAt a i) * t;
  in
    hsluvToHex [(lerp 0) (lerp 1) (lerp 2)];

  # Rotate hue by degrees (can be negative)
  rotateHue = hex: degrees: let
    hsl = hexToHSLuv hex;
  in
    hsluvToHex [
      (math.mod (builtins.elemAt hsl 0 + degrees) 360.0)
      (builtins.elemAt hsl 1)
      (builtins.elemAt hsl 2)
    ];

  # Complement (hue + 180)
  complement = hex: rotateHue hex 180.0;

  # RGB-space mix — no hue shift, faithful to how the official _10 tints work
  mixRGB = hexA: hexB: t: let
    a = hexToRGB hexA;
    b = hexToRGB hexB;
    lerp = i: builtins.elemAt a i + (builtins.elemAt b i - builtins.elemAt a i) * t;
  in
    rgbToHex [(lerp 0) (lerp 1) (lerp 2)];
}
