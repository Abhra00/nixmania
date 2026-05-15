{
  flake.modules.nixos.editor_helix = {
    hm.programs.helix.settings.keys = {
      normal = {
        space = {
          space = ":fmt";
          w = ":w";
          q = ":q";
          f = "file_picker";
          b = "buffer_picker";
          i = ":toggle lsp.display-inlay-hints";
        };
        tab = ":buffer-next";
        S-tab = ":buffer-previous";
      };
    };
  };
}
