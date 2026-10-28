{
  flake.modules.nixos.cli_lazygit = {
    hm.programs.lazygit = {
      enable = true;
      settings = {
        gui.border = "rounded";
        git.diffRenderers = [
          {
            name = "delta";
            colorArg = "always";
            command = "delta --paging=never";
          }
        ];
      };
    };
  };
}
