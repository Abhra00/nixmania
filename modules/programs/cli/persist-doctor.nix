{
  flake.modules.nixos.cli_persist-doctor = {
    config,
    pkgs,
    confDir,
    ...
  }: {
    hm.home.packages = [
      (pkgs.writeShellScriptBin "persist-doctor" ''
        set -euo pipefail

        # persist-doctor: list files/dirs in /persistent that preservation.nix does not declare.
        # Read-only by default. Usage: persist-doctor [--rm]
        #   --rm   ask per orphan whether to delete it
        # Env: FLAKE (default: confDir)  HOST (default: this host)  PERSIST (default /persistent)
        #      IGNORE (space-separated logical paths you manage yourself, default "/passwd")

        FLAKE=''${FLAKE:-${confDir}}
        HOST=''${HOST:-${config.networking.hostName}}
        PERSIST=''${PERSIST:-/persistent}
        IGNORE=''${IGNORE:-/passwd /zfs-keys}
        RM=0; [[ "''${1:-}" == "--rm" ]] && RM=1

        # Step 1 (as your user, so git/nix work): ask Nix what is declared.
        if [[ $EUID -ne 0 ]]; then
          if [[ -z "''${DECLARED_FILE:-}" ]]; then
            DECLARED_FILE=$(mktemp)
            nix eval --json "$FLAKE#nixosConfigurations.$HOST.config.preservation.preserveAt" \
              --apply 'pa: let
                n = e: if builtins.isString e then e else (e.directory or e.file);
                p = pa."'"$PERSIST"'";
              in {
                system = map n ((p.directories or []) ++ (p.files or []));
                users = builtins.mapAttrs (u: c: {
                  home = c.home or "/home/''${u}";
                  paths = map n ((c.directories or []) ++ (c.files or []));
                }) (p.users or {});
              }' \
            | ${pkgs.jq}/bin/jq -r '
                (.system[]),
                (.users | to_entries[] | .value.home as $h | .value.paths[]
                  | if startswith("/") then . else "\($h)/\(.)" end)
              ' > "$DECLARED_FILE"
          fi
          export DECLARED_FILE
          exec sudo --preserve-env=DECLARED_FILE,PERSIST,IGNORE,RM bash "$0" "$@"
        fi

        # Step 2 (as root): walk /persistent and report anything not covered.
        mapfile -t DECLARED < <(sed 's#/*$##' "$DECLARED_FILE" | sort -u)
        rm -f "$DECLARED_FILE"
        echo "declared paths: ''${#DECLARED[@]}"

        covered()  { local l=$1 d; for d in "''${DECLARED[@]}"; do [[ $l == "$d" || $l == "$d"/* ]] && return 0; done; return 1; }
        ancestor() { local l=$1 d; for d in "''${DECLARED[@]}"; do [[ $d == "$l"/* ]] && return 0; done; return 1; }
        ignored()  { local l=$1 i; for i in $IGNORE; do [[ $l == "$i" || $l == "$i"/* ]] && return 0; done; return 1; }

        ORPHANS=()
        walk() {
          local p l
          while IFS= read -r -d ''' p; do
            l=''${p#"$PERSIST"}
            ignored "$l" && continue
            if covered "$l"; then continue
            elif ancestor "$l"; then
              if [[ -d $p && ! -L $p ]]; then walk "$p"; fi
            else
              ORPHANS+=("$p")
            fi
          done < <(find "$1" -mindepth 1 -maxdepth 1 -print0 | sort -z)
        }
        walk "$PERSIST"

        if ((''${#ORPHANS[@]} == 0)); then echo "clean: nothing undeclared in $PERSIST"; exit 0; fi

        echo "undeclared in $PERSIST:"
        for p in "''${ORPHANS[@]}"; do
          printf '%8s  %s  %s\n' "$(du -sh "$p" | cut -f1)" "$(date -r "$p" +%F)" "$p"
        done

        if ((RM)); then
          for p in "''${ORPHANS[@]}"; do
            read -r -p "delete $p ? [y/N] " a </dev/tty
            [[ $a == y ]] && rm -rf -- "$p" && echo "removed"
          done
        fi
      '')
    ];
  };
}
