{
  flake.modules.nixos.cli_direnv = {
    hm = {config, ...}: {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.whitelist.prefix = ["${config.home.homeDirectory}/Projects"];
      };
    };
  };
}
