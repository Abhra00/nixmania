{
  flake.modules.nixos.base = {
    lib,
    username,
    ...
  }: {
    imports = [
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])
    ];

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    hm = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.preferXdgDirectories = true;
      home.stateVersion = "25.11";
    };
  };
}
