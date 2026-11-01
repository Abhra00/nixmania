{
  flake.modules.nixos.cli_yazi = {pkgs, ...}: {
    hm.programs.yazi = {
      plugins = {
        smart-enter = pkgs.yaziPlugins.smart-enter;
        lazygit = pkgs.yaziPlugins.lazygit;
        full-border = {
          package = pkgs.yaziPlugins.full-border;
          setup = true;
          settings = {
            set = "rounded";
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
