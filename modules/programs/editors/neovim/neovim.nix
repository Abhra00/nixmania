{
  flake.modules.nixos.editor_neovim = {
    confDir,
    pkgs,
    ...
  }: let
    nvimTools = with pkgs; [
      alejandra
      cargo
      clang-tools
      clippy
      emmet-language-server
      gcc
      lua-language-server
      nixd
      oxfmt
      oxlint
      rust-analyzer
      rustc
      rustfmt
      stylua
      superhtml
      tailwindcss-language-server
      tree-sitter
      vscode-css-languageserver
      vscode-json-languageserver
      vtsls
    ];

    configDir = "${confDir}/modules/programs/editors/neovim/config";
  in {
    hm = {config, ...}: let
      link = config.lib.file.mkOutOfStoreSymlink;
    in {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        extraPackages = nvimTools;
      };

      xdg.configFile."nvim/init.lua".source = link "${configDir}/init.lua";
      xdg.configFile."nvim/lua" = {
        source = link "${configDir}/lua";
        recursive = true;
      };
      xdg.configFile."nvim/snippets" = {
        source = link "${configDir}/snippets";
        recursive = true;
      };
      xdg.configFile."nvim/lsp" = {
        source = link "${configDir}/lsp";
        recursive = true;
      };
      xdg.configFile."nvim/nvim-pack-lock.json".source = link "${configDir}/nvim-pack-lock.json";
    };
  };
}
