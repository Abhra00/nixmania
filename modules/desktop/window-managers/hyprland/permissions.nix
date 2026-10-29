{
  flake.modules.nixos.window-manager_hyprland = {
    config,
    lib,
    ...
  }: let
    inherit (lib) escapeRegex optionals;

    # Hyprland matches the client's resolved binary path with a full-match
    # Rules follow package updates automatically
    exe = pkg: dir: name: "${escapeRegex (toString pkg)}/${dir}/\\.?${escapeRegex name}(-wrapped)?";

    portal = config.programs.hyprland.portalPackage;
    noctalia = config.hm.programs.noctalia.package or null;

    trusted =
      [(exe portal "libexec" "xdg-desktop-portal-hyprland")]
      ++ optionals (noctalia != null) [(exe noctalia "bin" "noctalia")];

    rule = type: mode: binary: {inherit binary type mode;};

    # Keyboards are matched by device name
    keyboards = [
      "at-translated-set-2-keyboard"
      "power-button"
      "sleep-button"
      "video-bus"
      "hl-virtual-keyboard-wtype"
      "hl-virtual-keyboard-.*noctalia.*"
    ];
  in {
    hm.wayland.windowManager.hyprland.settings = {
      config.ecosystem.enforce_permissions = true;

      # First match wins, and anything unmatched prompts
      permission =
        map (rule "screencopy" "allow") trusted
        ++ map (rule "cursorpos" "allow") trusted
        ++ [
          (rule "keyboard" "allow" (lib.concatStringsSep "|" keyboards))
          (rule "plugin" "deny" ".*")
          (rule "input-capture" "deny" ".*")
        ];
    };
  };
}
