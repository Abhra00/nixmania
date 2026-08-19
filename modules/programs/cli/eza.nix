{
  flake.modules.nixos.cli_eza = {
    hm.programs.eza = {
      enable = true;

      colors = "auto";
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
