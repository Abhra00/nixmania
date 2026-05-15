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
        C-y = [
          '':sh rm -f /tmp/unique-file''
          '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/unique-file''
          '':sh printf "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          '':open %sh{cat /tmp/unique-file}''
          '':redraw''
        ];
        tab = ":buffer-next";
        S-tab = ":buffer-previous";
      };
    };
  };
}
