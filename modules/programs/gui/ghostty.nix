{
  flake.modules.nixos.gui_ghostty = {
    hm.programs.ghostty = {
      enable = true;
      systemd.enable = true;

      settings = {
        adjust-cell-height = "15%";

        adjust-underline-position = 4;

        adjust-cursor-height = "15%";
        cursor-style = "block";
        cursor-style-blink = true;

        window-padding-x = 30;
        window-padding-y = 30;
        window-padding-balance = true;
        window-decoration = false;

        gtk-tabs-location = "bottom";
        gtk-wide-tabs = false;

        mouse-hide-while-typing = true;
        mouse-scroll-multiplier = 1;

        scrollback-limit = 10000;
        confirm-close-surface = false;

        shell-integration-features = "cursor,sudo,title";

        keybind = [
          # tabs
          "ctrl+shift+t=new_tab"
          "ctrl+shift+w=close_surface"
          "ctrl+shift+l=next_tab"
          "ctrl+shift+h=previous_tab"
          "ctrl+shift+r=prompt_tab_title"
          "ctrl+alt+t=toggle_tab_overview"

          # splits
          "ctrl+shift+enter=new_split:right"
          "ctrl+shift+minus=new_split:down"
          "ctrl+shift+left=goto_split:left"
          "ctrl+shift+right=goto_split:right"
          "ctrl+shift+up=goto_split:top"
          "ctrl+shift+down=goto_split:bottom"
          "ctrl+shift+x=close_surface"

          # resize splits
          "ctrl+alt+left=resize_split:left,10"
          "ctrl+alt+right=resize_split:right,10"
          "ctrl+alt+up=resize_split:up,10"
          "ctrl+alt+down=resize_split:down,10"

          # search
          "ctrl+shift+f=start_search"

          # selection
          "ctrl+shift+a=select_all"
          "performable:ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"

          # jump between prompts
          "ctrl+shift+page_up=jump_to_prompt:-1"
          "ctrl+shift+page_down=jump_to_prompt:1"

          # font size
          "ctrl+equal=increase_font_size:1"
          "ctrl+minus=decrease_font_size:1"
          "ctrl+zero=reset_font_size"

          # quick terminal
          "ctrl+alt+enter=toggle_quick_terminal"
        ];
      };
    };
  };
}
