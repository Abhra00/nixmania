{
  flake.modules.nixos.base = {
    hm = {
      config,
      lib,
      ...
    }: let
      devtoolsDir = "${config.xdg.dataHome}/devtools";
      esc = builtins.fromJSON ''"\u001b"'';
      bold = code: text: "${esc}[1;${code}m${text}";
      reset = "${esc}[0m";
    in {
      home.sessionVariables = {
        TERMINAL = "ghostty";
        BROWSER = "firefox";
        EDITOR = "nvim";
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        NIXOS_OZONE_WL = "1";
        NIXPKGS_ALLOW_UNFREE = "1";

        SUDO_PROMPT = lib.concatStrings [
          (bold "31" "[")
          (bold "33" "%p")
          (bold "31" "]")
          " "
          (bold "32" "Enter")
          " "
          (bold "34" "Sudo")
          " "
          (bold "35" "Password")
          "${reset}: "
        ];

        CARGO_HOME = "${devtoolsDir}/cargo";
        PNPM_HOME = "${devtoolsDir}/pnpm";
      };

      home.sessionPath = [
        "${devtoolsDir}/cargo/bin"
        "${devtoolsDir}/pnpm"
      ];
    };
  };
}
