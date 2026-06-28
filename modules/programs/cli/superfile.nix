{
  flake.modules.nixos.cli_superfile = {
    inputs,
    config,
    pkgs,
    ...
  }: {
    hm.programs.superfile = let
      c = config.lib.stylix.colors;
    in {
      enable = true;
      package = inputs.superfile.packages.${pkgs.stdenv.hostPlatform.system}.default;
      firstUseCheck = false;
      settings = {
        theme = "stylix";
        auto_check_update = false;
        code_previewer = "bat";
        border_top_left = "┌";
        border_top_right = "┐";
        border_bottom_left = "└";
        border_bottom_right = "┘";
        border_middle_left = "├";
        border_middle_right = "┤";
        border_top = "─";
        border_bottom = "─";
        border_left = "│";
        border_right = "│";
        ignore_missing_fields = true;
      };
      hotkeys = {
        cd_quit = ["Q" ""];
        split_file_panel = ["N" ""];
        permanently_delete_items = ["D" ""];
        open_zoxide = ["z" ""];
      };
      themes.stylix = {
        code_syntax_highlight = "base16-dark";
        full_screen_fg = "#${c.base05}";
        full_screen_bg = "#${c.base00}";
        gradient_color = ["#${c.base0D}" "#${c.base0E}"];
        directory_icon_color = "";
        file_panel_fg = "#${c.base05}";
        file_panel_bg = "#${c.base00}";
        file_panel_border = "#${c.base03}";
        file_panel_border_active = "#${c.base0D}";
        file_panel_top_directory_icon = "#${c.base0B}";
        file_panel_top_path = "#${c.base0C}";
        file_panel_item_selected_fg = "#${c.base0D}";
        file_panel_item_selected_bg = "#${c.base01}";
        footer_fg = "#${c.base05}";
        footer_bg = "#${c.base00}";
        footer_border = "#${c.base03}";
        footer_border_active = "#${c.base0B}";
        sidebar_fg = "#${c.base05}";
        sidebar_bg = "#${c.base00}";
        sidebar_title = "#${c.base0C}";
        sidebar_border = "#${c.base00}";
        sidebar_border_active = "#${c.base08}";
        sidebar_item_selected_fg = "#${c.base0D}";
        sidebar_item_selected_bg = "#${c.base01}";
        sidebar_divider = "#${c.base03}";
        modal_fg = "#${c.base05}";
        modal_bg = "#${c.base00}";
        modal_border_active = "#${c.base03}";
        modal_cancel_fg = "#${c.base00}";
        modal_cancel_bg = "#${c.base09}";
        modal_confirm_fg = "#${c.base00}";
        modal_confirm_bg = "#${c.base0C}";
        help_menu_hotkey = "#${c.base0C}";
        help_menu_title = "#${c.base08}";
        cursor = "#${c.base06}";
        correct = "#${c.base0B}";
        error = "#${c.base08}";
        hint = "#${c.base0C}";
        cancel = "#${c.base09}";
      };
    };
  };
}
