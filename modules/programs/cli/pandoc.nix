{
  flake.modules.nixos.cli_pandoc = {
    hm.programs.pandoc = {
      enable = true;
      defaults = {
        pdf-engine = "typst";
        highlight-style = "tango";
      };
    };
  };
}
