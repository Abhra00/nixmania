{
  flake.modules.nixos.cli_nix-search-tv = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      (pkgs.writeShellApplication {
        name = "nst";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        excludeShellChecks = ["SC2016"];
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })
    ];
  };
}
