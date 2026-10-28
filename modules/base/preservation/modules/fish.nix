{
  flake.modules.nixos.shell_fish = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      ".config/fish"
      ".local/share/fish"
    ];
  };
}
