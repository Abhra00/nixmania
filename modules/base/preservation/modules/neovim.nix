{
  flake.modules.nixos.editor_neovim = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      ".local/share/nvim"
      ".local/state/nvim"
    ];
  };
}
