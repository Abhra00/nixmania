{
  flake.modules.nixos.shell_bash = {
    imports = [./_common.nix];
    programs.bash = {
      enable = true;
      completion.enable = false;
    };
    hm.programs.bash = {
      enable = true;
      enableCompletion = false;
    };
  };
}
