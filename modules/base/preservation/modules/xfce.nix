{
  flake.modules.nixos.desktop-environment_xfce = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      ".config/xfce4"
      ".config/Thunar"
      ".local/share/xfce4"
    ];
  };
}
