{
  flake.modules.nixos.base = {
    config,
    lib,
    username,
    ...
  }: {
    users.mutableUsers = false;

    users.users = {
      root.hashedPasswordFile = "/persistent/passwd/root";

      ${username} = {
        isNormalUser = true;
        hashedPasswordFile = "/persistent/passwd/${username}";
        extraGroups =
          [
            "wheel"
            "audio"
            "video"
          ]
          ++ lib.optional config.security.tpm2.enable "tss"
          ++ lib.optionals config.hardware.sane.enable [
            "lp"
            "scanner"
          ];
      };
    };
  };
}
