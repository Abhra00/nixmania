{
  flake.modules.nixos.editor_helix = {
    hm.programs.helix = {
      enable = true;
      settings.editor = {
        # behavioural settings
        auto-info = true;
        auto-format = true;
        continue-comments = true;
        indent-heuristic = "hybrid";
        mouse = true;
        middle-click-paste = true;
        scrolloff = 15;
        scroll-lines = 5;
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        clipboard-provider = "wayland";
        default-yank-register = "+";
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 3000;
          };
        };

        # completion settings
        auto-completion = true;
        path-completion = true;
        completion-timeout = 200;
        completion-trigger-len = 2;
        completion-replace = true;

        # UI/UX
        popup-border = "none";
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        end-of-line-diagnostics = "disable";
        gutters.line-numbers.min-width = 2;
        line-number = "relative";
        rulers = [120];

        # cursor shapes
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "block";
        };

        # indent guides
        indent-guides = {
          render = true;
          character = "·";
          skip-levels = 1;
        };

        # lsp settings
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        # Diagnostics
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "disable";
          min-diagnostic-width = 20;
          max-wrap = 20;
          prefix-len = 1;
        };

        # soft wrap settings
        soft-wrap = {
          enable = true;
          wrap-indicator = "↳ ";
        };

        # statusline format
        statusline = {
          left = [
            "mode"
            "spacer"
            "spinner"
          ];
          center = [
            "version-control"
            "file-name"
            "file-modification-indicator"
            "read-only-indicator"
          ];
          right = [
            "diagnostics"
            "file-encoding"
            "position"
            "separator"
            "total-line-numbers"
          ];
          separator = "│";
          mode = {
            normal = "NOR";
            insert = "INS";
            select = "SEL";
          };
        };
      };
    };
  };
}
