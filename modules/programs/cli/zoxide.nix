{
  flake.modules.nixos.cli_zoxide = {
    hm.programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };
}
