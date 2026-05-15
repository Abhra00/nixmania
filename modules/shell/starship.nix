{
  flake.modules.nixos.shell_starship = {lib, ...}: {
    hm.programs.starship = {
      enable = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;
        command_timeout = 5000;
        directory.truncation_length = 5;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✘](bold red)";
        };
        git_status.disabled = true;
        package.disabled = true;
      };
      presets = ["nerd-font-symbols"];
    };
  };
}
