{
  flake.modules.nixos.login-manager_ly = {
    services.displayManager.ly = {
      enable = true;
      settings = {
        allow_empty_password = true;
        auth_fails = 5;
        clear_password = true;
        log_file = "/var/log/ly/ly.log";
        session_log = "/dev/null";
        animation = "doom";
        clock = "%H:%M:%S";
      };
    };
  };
}
