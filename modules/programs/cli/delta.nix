{
  flake.modules.nixos.cli_delta = {config, ...}: let
    colors = config.lib.stylix.colors;
  in {
    hm.programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "stylix";
        navigate = true;
        line-numbers = true;

        stylix = {
          dark = true;
          syntax-theme = "base16-stylix";
          line-numbers-minus-style = "#${colors.base08}";
          line-numbers-plus-style = "#${colors.base0B}";
          line-numbers-zero-style = "#${colors.base03}";
          line-numbers-left-style = "#${colors.base03}";
          line-numbers-right-style = "#${colors.base03}";
          file-style = "bold #${colors.base0A}";
          file-decoration-style = "#${colors.base0A} ul";
          hunk-header-style = "file line-number syntax";
          hunk-header-decoration-style = "#${colors.base0D} box";
        };
      };
    };
  };
}
