{
  flake.modules.nixos.cli_git = {
    programs.git.enable = true;
    hm.programs.git = {
      enable = true;
      settings = {
        user.name = "Abhra00";
        user.email = "114018452+Abhra00@users.noreply.github.com";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      includes = [
        {
          # GitHub Gist SSH
          condition = "hasconfig:remote.*.url:git@gist.github.com:*/**";
          contents.user.email = "114018452+Abhra00@users.noreply.github.com";
        }
        {
          # GitHub Gist URL
          condition = "hasconfig:remote.*.url:https://gist.github.com/**";
          contents.user.email = "114018452+Abhra00@users.noreply.github.com";
        }
        {
          # GitHub SSH
          condition = "hasconfig:remote.*.url:git@github.com:*/**";
          contents.user.email = "114018452+Abhra00@users.noreply.github.com";
        }
        {
          # GitHub URL
          condition = "hasconfig:remote.*.url:https://github.com/**";
          contents.user.email = "114018452+Abhra00@users.noreply.github.com";
        }
      ];
    };
  };
}
