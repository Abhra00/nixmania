# Stylix target for programs.drift
{
  config,
  lib,
  ...
}: let
  cfg = config.stylix.targets.drift;
  stx = config.lib.stylix.colors;
  hex = stx.withHashtag;

  # Accent slots used for the theme palette.
  accents = ["base0D" "base0E" "base0C" "base0B" "base0A" "base09" "base08"];

  # dim = dark tint of the accent: 75% background + 25% accent, per channel.
  toHex2 = n: let
    h = lib.toHexString n;
  in
    if lib.stringLength h < 2
    then "0${h}"
    else h;
  channel = name: ch:
    toHex2 ((3 * lib.toInt stx."base00-rgb-${ch}" + lib.toInt stx."${name}-rgb-${ch}") / 4);
  dimOf = name: "#${channel name "r"}${channel name "g"}${channel name "b"}";
in {
  options.stylix.targets.drift.enable =
    config.lib.stylix.mkEnableTarget "drift" true;

  config = lib.mkIf (config.stylix.enable && cfg.enable && config.programs.drift.enable) {
    programs.drift = {
      themes.stylix = {
        bright = hex.base06;
        palette = map (n: hex.${n}) accents;
        dim = map dimOf accents;
      };
      settings.engine.theme = lib.mkDefault "stylix";
    };
  };
}
