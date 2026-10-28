{config, ...}: {
  flake.modules.nixos.TR-100-machine = {pkgs, ...}: {
    users.defaultUserShell = pkgs.fish;
    system.stateVersion = "26.05";
    imports =
      (with config.flake.modules.nixos; [
        # storage
        storage_zfs-rollback

        # desktop
        desktop_common-packages
        desktop-shell_noctalia
        desktop_sound
        desktop_xkb
        display-manager_noctalia-greeter
        window-manager_hyprland

        # desktop/theming/*
        theming_defaults
        theming_fonts
        theming_extended-palette
        theming_stylix
        theming_system-fonts
        theming_targets

        # features/*
        feature_kvm
        feature_nix-ld

        # programs/cli/*
        cli_bat
        cli_btop
        cli_cava
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
        cli_gpu-screen-recorder
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

        # services/*
        service_bluetooth
        service_gnome-keyring
        service_gpg
        service_gvfs
        service_power-profiles-daemon
        service_ssh
        service_udiskie
        service_upower

        # services/rules/*
        rule_igpu

        # shell/*
        shell_aliases
        shell_bash
        shell_fish
      ])
      ++ [
        ./_hardware-configuration.nix
      ];
  };
}
