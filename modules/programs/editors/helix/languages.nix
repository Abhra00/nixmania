{
  flake.modules.nixos.editor_helix = {
    confDir,
    pkgs,
    ...
  }: {
    hm.programs.helix = {
      languages.language = [
        {
          name = "bash";
          auto-format = true;
          formatter.command = "${pkgs.shfmt}/bin/shfmt";
          language-servers = ["bash-language-server" "scls"];
        }
        {
          name = "c";
          auto-format = true;
          language-servers = ["clangd" "scls"];
        }
        {
          name = "css";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "css"];
          language-servers = ["vscode-css-language-server" "scls"];
        }
        {
          name = "html";
          auto-format = true;
          formatter.command = "${pkgs.superhtml}/bin/superhtml";
          formatter.args = ["fmt" "--stdin"];
          language-servers = ["superhtml" "scls"];
        }
        {
          name = "javascript";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "babel"];
          language-servers = ["typescript-language-server" "scls"];
        }
        {
          name = "json";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "json"];
          language-servers = ["vscode-json-language-server"];
        }
        {
          name = "jsx";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "babel"];
          language-servers = ["typescript-language-server" "scls"];
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
            "scls"
          ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
          language-servers = ["nil" "scls"];
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["basedpyright" "ruff" "scls"];
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
          language-servers = ["rust-analyzer" "scls"];
        }
        {
          name = "tsx";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "babel"];
          language-servers = ["typescript-language-server" "scls"];
        }
        {
          name = "typescript";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "typescript"];
          language-servers = ["typescript-language-server" "scls"];
        }
        {
          name = "yaml";
          auto-format = true;
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = ["--parser" "yaml"];
          file-types = ["yaml" "yml" {glob = "templates/*.yaml";}];
          language-servers = ["yaml-language-server" "scls"];
        }
      ];

      languages.language-server = {
        scls = {
          command = "${pkgs.simple-completion-language-server}/bin/simple-completion-language-server";
          environment = {
            SNIPPETS_PATH = "${confDir}/modules/programs/editors/helix/snippets";
          };
          config = {
            feature_words = false;
            feature_snippets = true;
            snippets_first = true;
          };
        };

        bash-language-server.command = "${pkgs.bash-language-server}/bin/bash-language-server";
        clangd.command = "${pkgs.clang-tools}/bin/clangd";
        marksman.command = "${pkgs.marksman}/bin/marksman";
        mpls = {
          command = "${pkgs.mpls}/bin/mpls";
          args = ["--no-auto" "--enable-emoji" "--dark-mode"];
        };
        nil = {
          command = "${pkgs.nil}/bin/nil";
          config.nil.nix.flake.autoArchive = true;
        };
        nixd.command = "${pkgs.nixd}/bin/nixd";
        basedpyright = {
          command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
          args = ["--stdio"];
        };
        ruff.command = "${pkgs.ruff}/bin/ruff";
        rust-analyzer.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        typescript-language-server = {
          command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          args = [
            "--stdio"
            "--tsserver-path=${pkgs.typescript}/lib/node_modules/typescript/lib"
          ];
        };
        superhtml = {
          command = "${pkgs.superhtml}/bin/superhtml";
          args = ["lsp"];
        };
        vscode-css-language-server = {
          command = "${pkgs.vscode-css-languageserver}/bin/vscode-css-languageserver";
          args = ["--stdio"];
        };
        vscode-json-language-server = {
          command = "${pkgs.vscode-json-languageserver}/bin/vscode-json-languageserver";
          args = ["--stdio"];
        };
        yaml-language-server = {
          command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          args = ["--stdio"];
        };
      };
    };
  };
}
