{
  flake.modules.nixos.cli_delta = {
    hm.programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
  };
}
