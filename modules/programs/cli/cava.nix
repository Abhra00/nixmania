{
  flake.modules.nixos.cli_cava = {
    hm.programs.cava = {
      enable = true;

      settings = {
        general.bar_width = 1;
        output = {
          channels = "mono";
        };
      };
    };
  };
}
