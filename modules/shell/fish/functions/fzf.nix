{
  flake.modules.nixos.shell_fish = {
    pkgs,
    config,
    lib,
    ...
  }: let
    ext = config.lib.stylix.extended-palette.colors;
    base = config.lib.stylix.colors;

    bare = lib.removePrefix "#";
    hash = c: "#${bare c}";

    toTruecolor = hex: let
      h = bare hex;
      channel = i: toString (lib.fromHexString (builtins.substring i 2 h));
    in "38;2;${channel 0};${channel 2};${channel 4}";

    brightBlue = bare ext.blue_bright;

    palette = {
      text = bare ext.fg;
      prompt = brightBlue;
      marker = bare ext.magenta500;
      pointer = bare ext.magenta500;
      directory = brightBlue;
      heading = brightBlue;
      key = base.base09;
      index = brightBlue;
      separator = base.base09;
    };

    syntaxColors = {
      command = base.base0D;
      builtin = base.base0D;
      function = base.base0D;
      keyword = base.base0E;
      quote = base.base0B;
      redirection = base.base0C;
      end = base.base09;
      error = base.base08;
      param = brightBlue;
      option = brightBlue;
      comment = base.base03;
      operator = base.base09;
      escape = base.base0E;
    };

    fishIndentColors =
      lib.concatStringsSep "\n"
      (lib.mapAttrsToList (name: color: "set -lx fish_color_${name} ${color}") syntaxColors);

    coreutil = name: "${pkgs.coreutils}/bin/${name}";
    bin = {
      fzf = "${pkgs.fzf}/bin/fzf";
      fish = "${pkgs.fish}/bin/fish";
      fishIndent = "${pkgs.fish}/bin/fish_indent";
      fd = "${pkgs.fd}/bin/fd";
      bat = "${pkgs.bat}/bin/bat";
      eza = "${pkgs.eza}/bin/eza";
      delta = "${pkgs.delta}/bin/delta";
      git = "${pkgs.git}/bin/git";
      grep = "${pkgs.gnugrep}/bin/grep";
      sed = "${pkgs.gnused}/bin/sed";
      ps = "${pkgs.procps}/bin/ps";
      pstree = "${pkgs.psmisc}/bin/pstree";
      ss = "${pkgs.iproute2}/bin/ss";
      lsof = "${pkgs.lsof}/bin/lsof";
      cat = coreutil "cat";
      head = coreutil "head";
      kill = coreutil "kill";
      ls = coreutil "ls";
      readlink = coreutil "readlink";
      sleep = coreutil "sleep";
    };

    fdExcludes = [".git" "node_modules" "target" "result"];
    fdCmd = "${bin.fd} --color=always --follow --strip-cwd-prefix ${lib.concatMapStringsSep " " (e: "--exclude ${e}") fdExcludes}";

    fdLsColors = pkgs.runCommand "fd-ls-colors" {} ''
      ${pkgs.vivid}/bin/vivid generate molokai \
        | ${coreutil "tr"} -d '\n' \
        | ${bin.sed} 's/\(^\|:\)di=[^:]*/\1di=${toTruecolor palette.directory}/' \
        > $out
    '';

    lsColorsEnv = ''set -lx LS_COLORS (${bin.cat} ${fdLsColors})'';

    gitStatusCmd = "${bin.git} -c core.quotePath=false -c color.status=false -c status.relativePaths=true status --short";
    psCmd = "${bin.ps} -eo pid,user:12,pcpu,pmem,etime,stat,comm --sort=-pcpu";

    pickers = [
      {
        name = "file";
        widget = "fzf_file_widget";
        description = "Search files with fd + fzf preview";
      }
      {
        name = "process";
        widget = "fzf_process_widget";
        description = "Browse processes with detailed info preview";
      }
      {
        name = "git_status";
        widget = "fzf_git_status_widget";
        description = "Browse and stage git status with diff preview";
      }
      {
        name = "git_log";
        widget = "fzf_git_log_widget";
        description = "Browse git log with commit preview";
      }
      {
        name = "history";
        widget = "fzf_history_widget";
        description = "Search shell history";
      }
      {
        name = "variable";
        widget = "fzf_variable_widget";
        description = "Search and preview shell variables";
      }
    ];

    processSections = [
      {
        title = "General";
        rows = [
          {
            label = "user";
            field = "user";
          }
          {
            label = "ppid";
            field = "ppid";
          }
          {
            label = "pgid";
            field = "pgid";
          }
          {
            label = "sid";
            field = "sid";
          }
          {
            label = "tty";
            field = "tty";
          }
          {
            label = "stat";
            field = "stat";
          }
          {
            label = "nice";
            field = "ni";
          }
          {
            label = "threads";
            field = "nlwp";
          }
          {
            label = "started";
            field = "lstart";
          }
          {
            label = "elapsed";
            field = "etime";
          }
        ];
      }
      {
        title = "Resources";
        rows = [
          {
            label = "cpu";
            field = "pcpu";
            unit = "%";
          }
          {
            label = "mem";
            field = "pmem";
            unit = "%";
          }
          {
            label = "rss";
            field = "rss";
            unit = " KiB";
          }
          {
            label = "vsz";
            field = "vsz";
            unit = " KiB";
          }
        ];
        extra = ''__fzf_module_kv fds (${bin.ls} /proc/$pid/fd 2>/dev/null | count)'';
      }
    ];

    psRow = {
      label,
      field,
      unit ? "",
    }: ''__fzf_module_kv ${label} (${bin.ps} -p $pid -o ${field}= | string trim)${lib.optionalString (unit != "") ''"${unit}"''}'';

    psSection = {
      title,
      rows,
      extra ? "",
    }: ''
      __fzf_module_heading ${title}
      ${lib.concatMapStringsSep "\n" psRow rows}
      ${extra}
      echo
    '';

    procLink = name: ''__fzf_module_kv ${name} (${bin.readlink} /proc/$pid/${name} 2>/dev/null; or echo "(no permission)")'';

    mkHiddenToggle = {
      cmd,
      label,
    }: ''--bind "ctrl-h:transform:string match -qr -- '\(hidden\)' \"\$FZF_PROMPT\"; and echo 'reload(${cmd})+change-prompt(${label}> )'; or echo 'reload(${cmd} --hidden)+change-prompt(${label} (hidden)> )'"'';

    mkWidget = body: ''
      ${body}
      commandline -f repaint
    '';
  in {
    hm.xdg.configFile."fish/completions/fzf-module.fish".text = ''
      complete -c fzf-module -f

      ${lib.concatMapStringsSep "\n" (p: "complete -c fzf-module -n '__fish_use_subcommand' -a ${p.name} -d '${p.description}'") pickers}
    '';

    hm.programs.fish.functions = {
      fzf-module = {
        description = "fzf-powered pickers: ${lib.concatMapStringsSep ", " (p: p.name) pickers}";
        body = ''
          switch $argv[1]
              ${lib.concatMapStringsSep "\n" (p: "case ${p.name}\n    ${p.widget}") pickers}
              case '*'
                  echo "fzf-module: unknown action '$argv[1]'" >&2
                  echo "valid actions: ${lib.concatMapStringsSep ", " (p: p.name) pickers}" >&2
                  return 1
          end
        '';
      };

      __fzf_module_run = ''
        ${bin.fzf} \
            --height 60% \
            --layout reverse \
            --with-shell '${bin.fish} -c' \
            --color 'fg:${hash palette.text},prompt:${hash palette.prompt},marker:${hash palette.marker},pointer:${hash palette.pointer}' \
            --border rounded \
            --margin 1,2 \
            --padding 1 \
            --preview-window right:60%:wrap \
            --marker '❖ ' \
            --pointer '➤ ' \
            $argv
      '';

      __fzf_module_heading = ''
        printf '%s── %s ──%s\n' (set_color ${palette.heading}) "$argv[1]" (set_color normal)
      '';

      __fzf_module_kv = ''
        printf '%s%-8s%s %s\n' (set_color ${palette.key}) "$argv[1]" (set_color normal) (string join ' ' -- $argv[2..-1])
      '';

      __fzf_module_is_binary = ''
        not ${bin.grep} -qI ''' -- $argv[1]
      '';

      __fzf_module_file_preview = ''
        set -l target $argv[1]

        if test -d $target
            ${bin.eza} --color always --icons -lA $target
        else if not test -e $target
            echo "Broken symlink (target does not exist)"
        else if not test -s $target
            echo "(empty file)"
        else if __fzf_module_is_binary $target
            echo "Binary file preview is not integrated intentionally"
        else
            ${bin.bat} --color=always --style=numbers --line-range :100 $target
        end
      '';

      __fzf_module_file = ''
        ${lsColorsEnv}

        ${fdCmd} \
            | __fzf_module_run \
                --ansi \
                --multi \
                --prompt "Search> " \
                --preview '__fzf_module_file_preview {}' \
                ${mkHiddenToggle {
          cmd = fdCmd;
          label = "Search";
        }}
      '';

      fzf_file_widget = mkWidget ''
        set -l selection (__fzf_module_file)

        for path in $selection
            commandline -i -- (string escape -- $path)" "
        end
      '';

      __fzf_module_process_preview = ''
        set -l pid $argv[1]

        if not test -d /proc/$pid
            echo "Process $pid no longer exists"
            return
        end

        __fzf_module_heading Command
        ${bin.ps} -p $pid -o args= | string trim
        echo

        ${lib.concatMapStringsSep "\n" psSection processSections}

        __fzf_module_heading Paths
        ${procLink "exe"}
        ${procLink "cwd"}
        echo

        __fzf_module_heading "Process tree"
        ${bin.pstree} -apT $pid 2>/dev/null
        echo

        __fzf_module_heading "Listening / sockets"
        set -l sockets (${bin.ss} -tulpnH 2>/dev/null | ${bin.grep} "pid=$pid,")
        if test -n "$sockets"
            printf '%s\n' $sockets
        else
            echo "(none visible)"
        end
        echo

        __fzf_module_heading "Open files"
        ${bin.lsof} -p $pid -n -P 2>/dev/null | ${bin.head} -n 25
      '';

      __fzf_module_process = ''
        ${psCmd} \
            | __fzf_module_run \
                --ansi \
                --multi \
                --header-lines 1 \
                --prompt "Process> " \
                --header "alt-k SIGTERM  alt-K SIGKILL  ctrl-r reload  enter insert PID" \
                --preview '__fzf_module_process_preview {1}' \
                --bind "ctrl-r:reload(${psCmd})" \
                --bind "alt-k:execute-silent(${bin.kill} {+1})+reload(${bin.sleep} 0.3; ${psCmd})" \
                --bind "alt-K:execute-silent(${bin.kill} -9 {+1})+reload(${bin.sleep} 0.3; ${psCmd})"
      '';

      fzf_process_widget = mkWidget ''
        set -l selection (__fzf_module_process)

        for line in $selection
            set -l pid (string split -f1 ' ' -- (string trim -- $line))
            commandline -i -- "$pid "
        end
      '';

      __fzf_module_git_path = ''
        set -l entry (string sub -s 4 -- $argv[1])
        set -l target (string replace -r -- '^.* -> ' "" $entry)
        string replace -r -- '^"(.*)"$' '$1' $target
      '';

      __fzf_module_git_diff_preview = ''
        set -l line $argv[1]
        set -l xy (string sub -l 2 -- $line)
        set -l file (__fzf_module_git_path $line)

        if test "$xy" = "??"
            __fzf_module_file_preview $file
        else if ${bin.git} rev-parse --verify -q HEAD >/dev/null
            ${bin.git} diff --color=always HEAD -- $file | ${bin.delta}
        else
            ${bin.git} diff --color=always --cached -- $file | ${bin.delta}
        end
      '';

      __fzf_module_git_toggle = ''
        for line in $argv
            set -l rest (string sub -s 4 -- $line)

            for raw in (string split -- ' -> ' $rest)
                set -l file (string replace -r '^"(.*)"$' '$1' -- $raw)

                if ${bin.git} diff --cached --quiet -- $file
                    ${bin.git} add -- $file
                else
                    ${bin.git} reset -q -- $file
                end
            end
        end
      '';

      __fzf_module_git_status = ''
        if not ${bin.git} rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo "fzf-module: not inside a git repository" >&2
            return 1
        end

        ${lsColorsEnv}

        ${gitStatusCmd} \
            | __fzf_module_run \
                --ansi \
                --multi \
                --prompt "Git Status> " \
                --header "alt-s stage/unstage  alt-a stage all" \
                --preview '__fzf_module_git_diff_preview {}' \
                --bind "alt-s:execute-silent(__fzf_module_git_toggle {+})+reload(${gitStatusCmd})" \
                --bind "alt-a:execute-silent(${bin.git} add -A)+reload(${gitStatusCmd})"
      '';

      fzf_git_status_widget = mkWidget ''
        set -l selection (__fzf_module_git_status)

        for line in $selection
            set -l file (__fzf_module_git_path $line)
            commandline -i -- (string escape -- $file)" "
        end
      '';

      __fzf_module_git_hash = ''
        echo $argv[1] | ${bin.grep} -oE '[0-9a-f]{7,40}' | ${bin.head} -n1
      '';

      __fzf_module_git_log_preview = ''
        set -l hash (__fzf_module_git_hash $argv[1])

        if test -z "$hash"
            echo "(no commit hash found on this line)"
        else
            ${bin.git} show --color=always $hash | ${bin.delta}
        end
      '';

      __fzf_module_git_log = ''
        if not ${bin.git} rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo "fzf-module: not inside a git repository" >&2
            return 1
        end

        set -l selection (${bin.git} log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' \
            | __fzf_module_run \
                --ansi \
                --prompt "Git Log> " \
                --preview '__fzf_module_git_log_preview {}')

        test -n "$selection"; and __fzf_module_git_hash $selection
      '';

      fzf_git_log_widget = mkWidget ''
        set -l hash (__fzf_module_git_log)

        if test -n "$hash"
            commandline -i -- "$hash"
        end
      '';

      __fzf_module_history_preview = ''
        ${fishIndentColors}
        echo -- $argv[1] | ${bin.fishIndent} --ansi
      '';

      __fzf_module_history = ''
        builtin history -z \
            | __fzf_module_run \
                --read0 \
                --ansi \
                --no-multi \
                --prompt "History> " \
                --preview '__fzf_module_history_preview {}'
      '';

      fzf_history_widget = mkWidget ''
        set -l selection (__fzf_module_history)

        if test -n "$selection"
            commandline -- (string join \n -- $selection)
        end
      '';

      __fzf_module_variable_preview = ''
        set -l name $argv[1]

        if test -z "$name"
            echo "(no variable selected)"
        else
            set -l cIndex (set_color ${palette.index})
            set -l cPipe (set_color ${palette.separator})
            set -l cReset (set_color normal)

            set -l output (set --show -- $name 2>&1)
            if test -z "$output"
                echo "(no info for '$name')"
            else
                string join -- \n $output \
                    | string replace --regex "^\\\$$name(?:: )?" "" \
                    | string replace --regex --all ': \|' ' |' \
                    | string replace --regex --all '(\[[0-9]+\])' "$cIndex\$1$cReset" \
                    | string replace --regex --all '\|' "$cPipe|$cReset"
            end
        end
      '';

      __fzf_module_variable = ''
        set -l varname (set -n \
            | __fzf_module_run \
                --no-multi \
                --prompt "Variable> " \
                --preview '__fzf_module_variable_preview {}')

        test -n "$varname"; and echo $$varname
      '';

      fzf_variable_widget = mkWidget ''
        set -l value (__fzf_module_variable)

        if test -n "$value"
            commandline -i -- "$value"
        end
      '';
    };
  };
}
