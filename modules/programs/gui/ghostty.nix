{
  flake.modules.nixos.gui_ghostty = {
    hm.programs.ghostty = {
      enable = true;
      systemd.enable = true;
      settings = {
        # Palette generation
        palette-generate = true;
        palette-harmonious = true;

        # Metrics
        adjust-cell-height = "5%";
        adjust-cursor-height = "5%";
        adjust-underline-thickness = "5%";
        adjust-cursor-thickness = "110%";
        adjust-underline-position = 3;

        # Cursor
        cursor-style = "block";
        cursor-style-blink = true;

        # Shell integration
        shell-integration-features = "sudo,cursor,ssh-env";

        # Splits
        unfocused-split-opacity = 0.4;

        # Confirmation
        confirm-close-surface = false;

        # Notifictions
        bell-features = "attention,no-system,no-title,no-border";
        notify-on-command-finish = "unfocused";

        # Window
        window-padding-x = 25;
        window-padding-y = 25;
        window-padding-balance = true;
        window-theme = "ghostty";

        # Key bindings
        keybind = [
          "alt+one=goto_tab:1"
          "alt+two=goto_tab:2"
          "alt+three=goto_tab:3"
          "alt+four=goto_tab:4"
          "alt+five=goto_tab:5"
          "alt+shift+t=new_tab"
          "alt+shift+comma=reload_config"
          "alt+shift+q=close_surface"
          "alt+equal=increase_font_size:1"
          "alt+minus=decrease_font_size:1"
          "alt+zero=reset_font_size"
          "alt+shift+v=new_split:right"
          "alt+shift+s=new_split:down"
          "alt+shift+k=goto_split:top"
          "alt+shift+j=goto_split:bottom"
          "alt+shift+h=goto_split:left"
          "alt+shift+l=goto_split:right"
          "alt+shift+y=copy_to_clipboard"
          "alt+shift+p=paste_from_clipboard"
          "alt+shift+b=write_screen_file:paste"
          "alt+shift+enter=toggle_fullscreen"
          "alt+shift+w=toggle_command_palette"
        ];
      };
    };
  };
}
