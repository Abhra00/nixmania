{
  flake.modules.nixos.editor_helix = {
    hm.programs.helix.settings.keys = {
      normal = {
        space = {
          space = ":fmt";
          w = ":w";
          q = ":q";
          i = ":toggle lsp.display-inlay-hints";
          x = ":buffer-close";
        };
        tab = ":buffer-next";
        S-tab = ":buffer-previous";
      };
    };
  };
}
