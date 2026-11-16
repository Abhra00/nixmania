{
  flake.modules.nixos.base = {username, ...}: {
    users.mutableUsers = false;

    users.users = {
      root.hashedPasswordFile = "/persistent/passwd/root";

      ${username} = {
        isNormalUser = true;
        hashedPasswordFile = "/persistent/passwd/${username}";
        extraGroups = [
          "wheel"
          "audio"
          "video"
        ];
      };
    };
  };
}
