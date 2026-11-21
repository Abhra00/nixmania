{
  flake.modules.nixos.window-manager_hyprland = {
    hm.wayland.windowManager.hyprland.settings = {
      config.animations.enabled = true;

      curve = [
        {
          _args = [
            "easeOutQuint"
            {
              type = "bezier";
              points = [[0.23 1] [0.32 1]];
            }
          ];
        }
        {
          _args = [
            "easeInOutCubic"
            {
              type = "bezier";
              points = [[0.65 0.05] [0.36 1]];
            }
          ];
        }
        {
          _args = [
            "easeOutExpo"
            {
              type = "bezier";
              points = [[0.16 1] [0.3 1]];
            }
          ];
        }
        {
          _args = [
            "easeInQuad"
            {
              type = "bezier";
              points = [[0.11 0] [0.5 0]];
            }
          ];
        }
        {
          _args = [
            "linear"
            {
              type = "bezier";
              points = [[0 0] [1 1]];
            }
          ];
        }
        {
          _args = [
            "easy"
            {
              type = "spring";
              mass = 1;
              stiffness = 238.1191;
              damping = 24.21279333;
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 5;
          spring = "easy";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 5;
          spring = "easy";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 4.5;
          spring = "easy";
          style = "popin 85%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 3;
          bezier = "easeInQuad";
          style = "popin 85%";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3.5;
          bezier = "easeOutQuint";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 3.5;
          bezier = "easeOutQuint";
          style = "fade";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 6;
          bezier = "easeInOutCubic";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 5;
          bezier = "easeOutExpo";
          style = "slidefade 15%";
        }
        {
          leaf = "zoomFactor";
          enabled = true;
          speed = 4;
          bezier = "easeOutQuint";
        }
      ];
    };
  };
}
