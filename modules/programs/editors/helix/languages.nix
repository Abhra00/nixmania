{
  flake.modules.nixos.editor_helix = {pkgs, ...}: {
    hm.programs.helix = {
      languages.language = [
        {
          name = "bash";
          auto-format = true;
          formatter.command = "${pkgs.shfmt}/bin/shfmt";
        }
        {
          name = "c";
          auto-format = true;
          language-servers = ["clangd"];
        }
        {
          name = "css";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "css"];
        }
        {
          name = "html";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "html"];
        }
        {
          name = "javascript";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "babel"];
        }
        {
          name = "json";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "json"];
        }
        {
          name = "jsx";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "babel"];
        }
        {
          name = "markdown";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "markdown"];
          language-servers = [
            "marksman"
            {
              name = "mpls";
              only-features = ["workspace-command"];
            }
          ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["basedpyright" "ruff"];
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
        {
          name = "tsx";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "babel"];
        }
        {
          name = "typescript";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "typescript"];
        }
        {
          name = "yaml";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "yaml"];
          file-types = ["yaml" "yml" {glob = "templates/*.yaml";}];
        }
      ];
      languages.language-server = {
        # Bash
        bash-language-server.command = "${pkgs.bash-language-server}/bin/bash-language-server";
        # C
        clangd.command = "${pkgs.clang-tools}/bin/clangd";
        # Markdown
        marksman.command = "${pkgs.marksman}/bin/marksman";
        mpls = {
          command = "${pkgs.mpls}/bin/mpls";
          args = ["--no-auto" "--enable-emoji" "--dark-mode"];
        };
        # Nix
        nil = {
          command = "${pkgs.nil}/bin/nil";
          config.nil.nix.flake.autoArchive = true;
        };
        nixd.command = "${pkgs.nixd}/bin/nixd";
        # Python
        basedpyright = {
          command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
          args = ["--stdio"];
        };
        ruff.command = "${pkgs.ruff}/bin/ruff";
        # Rust
        rust-analyzer.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        # PERN
        typescript-language-server = {
          command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          args = [
            "--stdio"
            "--tsserver-path=${pkgs.typescript}/lib/node_modules/typescript/lib"
          ];
        };
        vscode-css-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
          args = ["--stdio"];
        };
        vscode-html-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
          args = ["--stdio"];
        };
        vscode-json-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
          args = ["--stdio"];
        };
      };
    };
  };
}
