{
  flake.modules.nixos.gui_foot = {
    hm.programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "foot";
          pad = "30x30 center-when-maximized-and-fullscreen";
        };

        "desktop-notifications" = {
          command = "noctalia msg notification-show \${title} \${body}";
        };

        bell = {
          system = "yes";
          urgent = "yes";
          notify = "yes";
          visual = "yes";
        };

        scrollback = {
          lines = 10000;
          multiplier = 3.0;
          indicator-position = "fixed";
          indicator-format = "percentage";
        };

        cursor = {
          style = "block";
          blink = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };

        url = {
          launch = "xdg-open ${"\${url}"}";
          osc8-underline = "url-mode";
        };

        key-bindings = {
          scrollback-up-line = "Control+k";
          scrollback-down-line = "Control+j";
          scrollback-up-page = "Control+b";
          scrollback-down-page = "Control+f";
          scrollback-home = "Control+g";
          scrollback-end = "Control+Shift+g";
        };

        search-bindings = {
          cancel = "Control+g Escape";
          commit = "Return";
        };
      };
    };
  };
}
