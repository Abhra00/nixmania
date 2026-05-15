{
  flake.modules.nixos.cli_packages = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      dysk
      fd
      gdu
      ripgrep
      bc
    ];
  };

  flake.modules.nixos.gui_packages = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      file-roller
    ];
  };
}
