{
  flake.modules.nixos.shell_readline = {
    hm.programs.readline = {
      enable = true;
      includeSystemConfig = true;
      variables = {
        bell-style = "none";
        colored-completion-prefix = true;
        colored-stats = true;
        skip-completed-text = true;
        completion-ignore-case = true;
        completion-map-case = true;
        completion-query-items = 200;
        expand-tilde = true;
        mark-symlinked-directories = true;
        match-hidden-files = false;
        page-completions = false;
        show-all-if-ambiguous = true;
        show-all-if-unmodified = true;
        visible-stats = true;
        editing-mode = "emacs";
      };
      bindings = {
        "\\C-n" = "history-search-forward";
        "\\C-p" = "history-search-backward";
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
        "\\e[Z" = "menu-complete-backward";
        TAB = "menu-complete";
      };
    };
  };
}
