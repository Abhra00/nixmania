{
  flake.modules.nixos.shell_fish = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors;
    estx = config.lib.stylix.extended-palette.colors;
    brBlue = lib.removePrefix "#" estx.blue_bright;

    themeLines = [
      "fish_color_normal --reset"
      "fish_color_command ${stx.base0D}"
      "fish_color_builtin ${stx.base0D}"
      "fish_color_function ${stx.base0D}"
      "fish_color_keyword ${stx.base0E}"
      "fish_color_quote ${stx.base0B}"
      "fish_color_redirection ${stx.base0C}"
      "fish_color_end ${stx.base09}"
      "fish_color_error ${stx.base08}"
      "fish_color_param ${brBlue}"
      "fish_color_valid_path ${brBlue} --underline"
      "fish_color_option ${brBlue}"
      "fish_color_comment ${stx.base03}"
      "fish_color_selection --background=${stx.base02}"
      "fish_color_operator ${stx.base09}"
      "fish_color_escape ${stx.base0E}"
      "fish_color_autosuggestion ${stx.base03}"
      "fish_color_cwd ${stx.base0B}"
      "fish_color_cwd_root ${stx.base08}"
      "fish_color_user ${stx.base0B}"
      "fish_color_host ${stx.base0D}"
      "fish_color_host_remote ${stx.base0A}"
      "fish_color_status ${stx.base08}"
      "fish_color_cancel -r"
      "fish_color_search_match --background=${stx.base02}"
      "fish_color_history_current --bold"
      "fish_pager_color_progress ${stx.base0D}"
      "fish_pager_color_prefix ${stx.base0D} --bold --underline"
      "fish_pager_color_completion ${stx.base05}"
      "fish_pager_color_description ${stx.base04}"
      "fish_pager_color_selected_background --background=${stx.base02}"
      "fish_pager_color_selected_prefix ${stx.base0D} --bold --underline"
      "fish_pager_color_selected_completion ${stx.base0E}"
      "fish_pager_color_selected_description ${stx.base04}"
      "fish_pager_color_secondary_prefix ${stx.base0D}"
      "fish_pager_color_secondary_completion ${stx.base05}"
      "fish_pager_color_secondary_description ${stx.base03}"
    ];
  in {
    hm.programs.fish.interactiveShellInit = lib.mkIf cfg (
      lib.concatMapStringsSep "\n" (line: "set -g ${line}") themeLines
    );
  };
}
