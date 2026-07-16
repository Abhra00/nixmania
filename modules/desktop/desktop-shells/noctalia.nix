{
  flake.modules.nixos.desktop-shell_noctalia = {
    hm = {inputs, ...}: {
      imports = [inputs.noctalia.homeModules.default];
      programs.noctalia.enable = true;
    };
  };
}
