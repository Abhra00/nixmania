{
  flake.modules.nixos.cli_git = let
    email = "114018452+Abhra00@users.noreply.github.com";
    gistEmail = email;

    mkIncludes = userEmail: urls:
      map (url: {
        condition = "hasconfig:remote.*.url:${url}";
        contents.user.email = userEmail;
      })
      urls;
  in {
    programs.git.enable = true;
    hm.programs.git = {
      enable = true;

      signing = {
        key = "5D04E590DC165C39E5A47248D5546BC7D22C69ED";
        format = "openpgp";
        signByDefault = true;
      };

      settings = {
        user.name = "Abhra00";
        user.email = email;
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        fetch.prune = true;
        merge.conflictStyle = "zdiff3";
        rerere.enabled = true;
        diff.algorithm = "histogram";
      };

      includes =
        mkIncludes email [
          "git@github.com:*/**"
          "ssh://git@github.com/**"
          "http*://github.com/**"
          "https://*@github.com/**"
        ]
        ++ mkIncludes gistEmail [
          "git@gist.github.com:**"
          "http*://gist.github.com/**"
        ];
    };
  };
}
