{
  flake.modules.nixos.cli_yazi = {
    hm.programs.yazi = {
      keymap = {
        mgr.prepend_keymap = [
          {
            on = ["l"];
            run = "plugin smart-enter";
            desc = "Enter or open";
          }
          {
            on = ["g" "i"];
            run = "plugin lazygit";
            desc = "run lazygit";
          }
        ];
      };
    };
  };
}
