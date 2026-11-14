{
  flake.modules.nixos.cli_gh = {
    hm.programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
      hosts."github.com" = {
        user = "Abhra00";
        git_protocol = "ssh";
      };
    };
  };
}
