{
  flake.modules.nixos.gui_firefox = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      ".config/mozilla"
    ];
  };
}
