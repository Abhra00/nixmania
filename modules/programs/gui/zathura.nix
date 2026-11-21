{
  flake.modules.nixos.gui_zathura = {
    hm.programs.zathura = {
      enable = true;

      options = {
        recolor = true;
      };

      mappings = {
        i = "recolor";
      };
    };
  };
}
