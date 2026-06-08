{config, ...}: {
  flake.modules.nixos.TR-100-machine = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_zen;
    users.defaultUserShell = pkgs.bash;
    system.stateVersion = "25.11";
    imports =
      (with config.flake.modules.nixos; [
        # base
        base

        # desktop
        desktop_common-packages
        desktop-shell_noctalia
        desktop_sound
        desktop_xkb
        login-manager_ly
        window-manager_niri

        # desktop/theming/*
        theming_defaults
        theming_fonts
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
        cli_eza
        cli_fastfetch
        cli_fzf
        cli_git
        cli_lazygit
        cli_nh
        cli_nix-index
        cli_nix-search-tv
        cli_packages
        cli_tmux
        cli_yazi
        cli_zoxide

        # programs/editor/*
        editor_helix
        editor_vim

        # programs/gui/*
        gui_firefox
        gui_ghostty
        gui_mpv
        gui_nautilus
        gui_packages
        gui_satty
        gui_zathura

        # services/*
        service_bluetooth
        service_gpg
        service_gvfs
        service_postgresql
        service_power-profiles-daemon
        service_udiskie
        service_upower

        # shell/*
        shell_aliases
        shell_bash
        shell_readline
        shell_starship
      ])
      ++ [
        ./_hardware-configuration.nix
        ./_disko.nix
      ];
  };
}
