{
  flake.modules.nixos.cli_lazygit = {
    hm.programs.lazygit = {
      enable = true;
      settings = {
        gui.border = "single";
      };
    };
  };
}
