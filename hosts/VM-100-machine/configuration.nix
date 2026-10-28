{config, ...}: {
  flake.modules.nixos.VM-100-machine = {pkgs, ...}: {
    system.stateVersion = "26.05";
    users.defaultUserShell = pkgs.fish;

    imports = with config.flake.modules.nixos; [
      # storage / vm
      storage_zfs-rollback
      vm_guest

      # desktop
      desktop-environment_xfce
      display-manager_lightdm
      desktop_sound
      desktop_xkb

      # desktop/theming/*
      theming_defaults
      theming_fonts
      theming_extended-palette
      theming_stylix
      theming_system-fonts
      theming_targets

      # features/*
      feature_nix-ld

      # programs/cli/*
      cli_bat
      cli_btop
      cli_chafa
      cli_comma
      cli_delta
      cli_devenv
      cli_direnv
      cli_dfetch
      cli_eza
      cli_fastfetch
      cli_fd
      cli_fzf
      cli_gh
      cli_git
      cli_lazygit
      cli_nh
      cli_nix-index
      cli_nix-search-tv
      cli_packages
      cli_persist-doctor
      cli_ripgrep
      cli_tmux
      cli_vivid
      cli_yazi
      cli_zoxide

      # programs/editor/*
      editor_neovim

      # programs/gui/*
      gui_firefox
      gui_ghostty
      gui_mpv
      gui_nautilus
      gui_packages
      gui_zathura

      # services/* (sops-backed ones are here for signed commits)
      service_gnome-keyring
      service_gpg
      service_gvfs
      service_ssh
      service_xrandr

      # shell/*
      shell_aliases
      shell_bash
      shell_fish
    ];
  };
}
