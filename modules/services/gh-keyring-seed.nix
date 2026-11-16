{
  flake.modules.nixos.service_gh-keyring-seed = {
    config,
    pkgs,
    username,
    ...
  }: {
    systemd.user.services.gh-keyring-seed = {
      description = "Seed gh token into the login keyring";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      unitConfig.ConditionUser = username;
      path = [pkgs.libsecret pkgs.coreutils];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
      script = ''
        secret-tool lookup service gh:github.com username Abhra00 >/dev/null 2>&1 && exit 0
        tr -d '\n' < ${config.sops.secrets.gh_token.path} \
          | secret-tool store --label="Password for 'Abhra00' on 'gh:github.com'" \
              service gh:github.com username Abhra00
      '';
    };
  };
}
