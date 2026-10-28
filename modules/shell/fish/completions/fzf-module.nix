{
  flake.modules.nixos.shell_fish = {
    hm.xdg.configFile."fish/completions/fzf-module.fish".text = ''
      complete -c fzf-module -f
      complete -c fzf-module -n '__fish_use_subcommand' -a file -d 'Search files with fd + fzf preview'
      complete -c fzf-module -n '__fish_use_subcommand' -a process -d 'Browse processes with detailed info preview'
      complete -c fzf-module -n '__fish_use_subcommand' -a git_status -d 'Browse git status with diff preview'
      complete -c fzf-module -n '__fish_use_subcommand' -a git_log -d 'Browse git log with commit preview'
      complete -c fzf-module -n '__fish_use_subcommand' -a history -d 'Search shell history'
      complete -c fzf-module -n '__fish_use_subcommand' -a variable -d 'Search and preview shell variables'
    '';
  };
}
