{
  flake.modules.nixos.cli_yazi = {
    lib,
    pkgs,
    ...
  }: {
    hm.programs.yazi = {
      plugins = {
        smart-enter = pkgs.yaziPlugins.smart-enter;
        lazygit = pkgs.yaziPlugins.lazygit;
        full-border = {
          package = pkgs.yaziPlugins.full-border;
          setup = true;
          settings = {
            type = lib.generators.mkLuaInline "ui.Border.PLAIN";
          };
        };
        git = {
          package = pkgs.yaziPlugins.git;
          setup = true;
        };
      };
    };
  };
}
