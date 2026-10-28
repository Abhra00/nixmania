{
  flake.modules.nixos.cli_fzf = {
    hm.programs.fzf = {
      enable = true;
      defaultOptions = [
        "--layout=reverse-list"
        "--style=default"
        "--info=default"
      ];
      defaultCommand = builtins.concatStringsSep " " [
        "fd --type f"
        "--hidden"
        "--follow"
        "--strip-cwd-prefix"
        "--exclude .git"
        "--exclude node_modules"
        "--exclude target"
        "--exclude result"
      ];
    };
  };
}
