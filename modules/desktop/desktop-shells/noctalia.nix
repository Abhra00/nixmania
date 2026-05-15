{
  flake.modules.nixos.desktop-shell_noctalia = {
    services.upower.enable = true;

    hm = {inputs, ...}: {
      imports = [inputs.noctalia.homeModules.default];
      programs.noctalia-shell.enable = true;
    };
  };
}
