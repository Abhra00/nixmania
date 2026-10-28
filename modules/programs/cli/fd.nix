{
  flake.modules.nixos.cli_fd = {
    hm.programs.fd = {
      enable = true;
      hidden = true;
      ignores = [".git/" "node_modules/"];
    };
  };
}
