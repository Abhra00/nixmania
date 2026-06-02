{
  flake.modules.nixos.shell_bash = {config, ...}: {
    imports = [./_common.nix];
    programs.bash = {
      enable = true;
      completion.enable = true;
      promptInit = ''
        PS1='\[\e[1;2m\][\[\e[0m\] \[\e[93;1m\]\u\[\e[39m\]@\h\[\e[0m\] \[\e[2m\]in\[\e[0m\] \[\e[93;1m\]\w\[\e[0m\] \[\e[1;2m\]]\[\e[0m\] \[\e[1;2m\]\\$\[\e[0m\] '
      '';
    };
    hm.programs.bash = {
      enable = true;
      enableCompletion = true;
      historySize = 32768;
      historyFile = "${config.hm.xdg.dataHome}/bash/history";
      historyFileSize = 32768;
      historyControl = ["ignoredups" "ignorespace" "ignoreboth" "erasedups"];
      historyIgnore = ["ls" "cd" "exit" "clear"];
      shellOptions = [
        "histappend"
        "autocd"
        "cdspell"
        "dirspell"
        "globstar"
        "checkwinsize"
        "extglob"
        "nocaseglob"
        "cmdhist"
        "lithist"
        "no_empty_cmd_completion"
      ];
      initExtra = ''
        prompt_marker() {
            printf '\e]133;A\e\\'
        }
        osc7_cwd() {
            local strlen=''${#PWD}
            local encoded=""
            local pos c o
            local sq=$(printf "\x27")
            for (( pos=0; pos<strlen; pos++ )); do
              c=''${PWD:$pos:1}
              case "$c" in
                [-/:_.!()~[:alnum:]] ) o="''${c}" ;;
                * ) printf -v o "%%%02X" "$sq''${c}" ;;
              esac
              encoded+="''${o}"
            done
            printf "\e]7;file://%s%s\a" "''${HOSTNAME}" "''${encoded}"
        }
        PROMPT_COMMAND=''${PROMPT_COMMAND:+$PROMPT_COMMAND; }prompt_marker
        PROMPT_COMMAND=''${PROMPT_COMMAND:+''${PROMPT_COMMAND%;}; }osc7_cwd
      '';
    };
  };
}
