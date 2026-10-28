{
  flake.modules.nixos.desktop-shell_noctalia = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      ".local/state/noctalia"
    ];
  };
}
