{
  flake.modules.nixos.service_glance = {
    hm.services.glance = {
      enable = true;
      settings = {
        server = {
          host = "127.0.0.1";
          port = 5678;
        };

        branding.hide-footer = true;

        pages = [
          {
            name = "Home";
            center-vertically = true;
            columns = [
              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    search-engine = "startpage";
                    new-tab = false;
                    bangs = [
                      {
                        title = "YouTube";
                        shortcut = "!yt";
                        url = "https://www.youtube.com/results?search_query={QUERY}";
                      }
                      {
                        title = "GitHub";
                        shortcut = "!gh";
                        url = "https://github.com/search?q={QUERY}";
                      }
                    ];
                  }
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        same-tab = true;
                        links = [
                          {
                            title = "Gmail";
                            url = "https://mail.google.com/mail/u/0/";
                            icon = "si:gmail";
                          }
                          {
                            title = "GitHub";
                            url = "https://github.com";
                            icon = "si:github";
                          }
                          {
                            title = "Reddit";
                            url = "https://reddit.com";
                            icon = "si:reddit";
                          }
                          {
                            title = "YouTube";
                            url = "https://youtube.com";
                            icon = "si:youtube";
                          }
                        ];
                      }
                      {
                        title = "Nix";
                        color = "200 70 60";
                        same-tab = true;
                        links = [
                          {
                            title = "Hydra";
                            url = "https://hydra.nixos.org/jobset/nixpkgs/unstable#tabs-jobs";
                            icon = "si:nixos";
                          }
                          {
                            title = "Nixpkgs";
                            url = "https://github.com/NixOS/nixpkgs";
                            icon = "si:nixos";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
