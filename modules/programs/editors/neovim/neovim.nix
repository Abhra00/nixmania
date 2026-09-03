{
  flake.modules.nixos.editor_neovim = {pkgs, ...}: let
    nvimTools = with pkgs; [
      nixd
      alejandra
      tree-sitter
      stylua
    ];
  in {
    hm = {config, ...}: let
      configDir = "${config.home.homeDirectory}/nixmania/modules/programs/editors/neovim/config";
      link = config.lib.file.mkOutOfStoreSymlink;
    in {
      programs.neovim = {
        enable = true;
        defaultEditor = false;
        viAlias = false;
        vimAlias = false;
        extraPackages = nvimTools;
      };

      xdg.configFile."nvim/init.lua".source = link "${configDir}/init.lua";
      xdg.configFile."nvim/lua" = {
        source = link "${configDir}/lua";
        recursive = true;
      };
      xdg.configFile."nvim/plugin" = {
        source = link "${configDir}/plugin";
        recursive = true;
      };
    };
  };
}
