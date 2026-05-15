{
  flake.modules.nixos.cli_tmux = {
    pkgs,
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    c = config.lib.stylix.colors;
    sysinfo = pkgs.writeShellScriptBin "tmux-sysinfo" ''
      #!/usr/bin/env bash

      MAGENTA="#${c.base0E}"
      GREEN="#${c.base0B}"
      ORANGE="#${c.base09}"
      RED="#${c.base08}"
      FG="#${c.base05}"
      BG="default"

      LOW_THRESHOLD=50
      HIGH_THRESHOLD=80

      SYSINFO_DIR="''${XDG_RUNTIME_DIR:-/tmp}/tmux-sysinfo"
      mkdir -p "$SYSINFO_DIR"

      style() { echo -n "#[fg=$1,bg=$BG]"; }

      usage_color() {
        local pct=$1
        if   (( pct >= HIGH_THRESHOLD )); then echo "$RED"
        elif (( pct >= LOW_THRESHOLD  )); then echo "$ORANGE"
        else echo "$GREEN"
        fi
      }

      get_status_interval() {
        ${pkgs.tmux}/bin/tmux show-option -gv status-interval 2>/dev/null || echo 5
      }

      ensure_running() {
        local pidfile="$1"; shift
        if [[ -f "$pidfile" ]] && kill -0 "$(cat "$pidfile" 2>/dev/null)" 2>/dev/null; then
          return
        fi
        "$@" </dev/null >/dev/null 2>&1 &
        disown
        echo $! > "$pidfile"
      }

      atomic_write() {
        local file="$1" value="$2"
        echo "$value" > "$file.tmp" && mv "$file.tmp" "$file"
      }

      cpu_collect() {
        local metric_file="$1"
        local prev_idle=0 prev_total=0 first=1
        while true; do
          read -r _ user nice system idle iowait irq softirq steal _ _ < /proc/stat
          local idle_all=$(( idle + iowait ))
          local total=$(( user + nice + system + idle + iowait + irq + softirq + steal ))

          if (( first == 0 )); then
            local diff_idle=$(( idle_all - prev_idle ))
            local diff_total=$(( total - prev_total ))
            local pct=0
            (( diff_total > 0 )) && pct=$(( (diff_total - diff_idle) * 100 / diff_total ))
            atomic_write "$metric_file" "$pct"
          fi

          prev_idle=$idle_all
          prev_total=$total
          first=0
          sleep 1
        done
      }

      mem_collect() {
        local interval="$1" metric_file="$2"
        while true; do
          read -r pct used_gb < <(${pkgs.procps}/bin/free -m | awk '/Mem:/{printf "%.0f %.1f", $3/$2*100, $3/1024}')
          atomic_write "$metric_file" "$pct $used_gb"
          sleep "$interval"
        done
      }

      cmd_cpu() {
        local metric_file="$SYSINFO_DIR/cpu.metric" pidfile="$SYSINFO_DIR/cpu.pid"
        ensure_running "$pidfile" "$0" _cpu_collect "$metric_file"
        local pct color
        pct=$(cat "$metric_file" 2>/dev/null || echo 0)
        color=$(usage_color "$pct")
        echo -n "$(style "$MAGENTA")C:$(style "$color")''${pct}%$(style "$FG")"
      }

      cmd_mem() {
        local metric_file="$SYSINFO_DIR/mem.metric" pidfile="$SYSINFO_DIR/mem.pid"
        local interval; interval=$(get_status_interval)
        ensure_running "$pidfile" "$0" _mem_collect "$interval" "$metric_file"
        local pct used_gb color
        read -r pct used_gb < "$metric_file" 2>/dev/null || { pct=0; used_gb=0.0; }
        color=$(usage_color "$pct")
        echo -n "$(style "$MAGENTA")M:$(style "$color")''${used_gb}G$(style "$FG")"
      }

      net_totals() {
        awk -F: '
          /:/ {
            iface=$1; gsub(/^ +| +$/,"",iface)
            if (iface != "lo") {
              split($2, a, " ")
              rx += a[1]
              tx += a[9]
            }
          }
          END { print rx, tx }
        ' /proc/net/dev
      }

      humanize() {
        local bytes=$1
        if   (( bytes >= 1048576 )); then printf "%dM/s" $(( bytes / 1048576 ))
        elif (( bytes >= 1024 ));    then printf "%dK/s" $(( bytes / 1024 ))
        else                              printf "%dB/s" "$bytes"
        fi
      }

      net_rate() {
        local state="$1" field="$2"
        local now rx tx cur prev_val prev_time dt rate

        read -r rx tx < <(net_totals)
        cur=$([[ "$field" == 1 ]] && echo "$rx" || echo "$tx")
        now=$(date +%s)

        if [[ -f "$state" ]]; then
          read -r prev_val prev_time < "$state"
          dt=$(( now - prev_time ))
          (( dt < 1 )) && dt=1
          rate=$(( (cur - prev_val) / dt ))
        else
          rate=0
        fi

        echo "$cur $now" > "$state"
        humanize "$rate"
      }

      cmd_net_down() { echo -n "$(net_rate "$SYSINFO_DIR/net-down.state" 1)"; }
      cmd_net_up()   { echo -n "$(net_rate "$SYSINFO_DIR/net-up.state" 2)"; }

      case "$1" in
        cpu)          cmd_cpu ;;
        mem)          cmd_mem ;;
        net_up)       cmd_net_up ;;
        net_down)     cmd_net_down ;;
        _cpu_collect) shift; cpu_collect "$@" ;;
        _mem_collect) shift; mem_collect "$@" ;;
        *) echo "usage: tmux-sysinfo {cpu|mem|net_up|net_down}" >&2; exit 1 ;;
      esac
    '';
  in {
    hm.home.packages = [sysinfo];
    hm.programs.tmux.extraConfig = lib.mkIf cfg ''
      # Theme
      set -g status-right-style "none"
      set -g status-left-style "none"
      set -g message-command-style "fg=#${c.base05},bg=#${c.base02}"
      set -g pane-active-border-style "fg=#${c.base0D}"
      set -g status-style "none,bg=#${c.base01}"
      set -g message-style "fg=#${c.base05},bg=#${c.base02}"
      set -g pane-border-style "fg=#${c.base02}"
      set -g status-right-length "100"
      set -g status-left-length "100"
      setw -g window-status-activity-style "none,fg=#${c.base0D},bg=#${c.base01}"
      setw -g window-status-separator ""
      setw -g window-status-style "none,fg=#${c.base05},bg=#${c.base01}"

      # Status Left
      set -g status-left "#[fg=#${c.base00},bg=#${c.base0D}] #S #[fg=#${c.base0D},bg=#${c.base02},nobold,nounderscore,noitalics]#[fg=#${c.base05},bg=#${c.base02}] %R #[fg=#${c.base02},bg=#${c.base01},nobold,nounderscore,noitalics]#[fg=#${c.base05},bg=#${c.base01}] #(tmux-sysinfo cpu) #[fg=#${c.base0D}] 󰕒 #(tmux-sysinfo net_up) #[fg=#${c.base01},bg=#${c.base01},nobold,nounderscore,noitalics]"

      # Status Right
      set -g status-right "#[fg=#${c.base01},bg=#${c.base01},nobold,nounderscore,noitalics]#[fg=#${c.base0D},bg=#${c.base01}] #(tmux-sysinfo net_down) 󰇚  #(tmux-sysinfo mem) #[fg=#${c.base02},bg=#${c.base01},nobold,nounderscore,noitalics]#[fg=#${c.base05},bg=#${c.base02}] %a #[fg=#{?client_prefix,#${c.base0E},#${c.base0D}},bg=#${c.base02},nobold,nounderscore,noitalics]#[fg=#${c.base00},bg=#{?client_prefix,#${c.base0E},#${c.base0D}}] #H "

      # Window Status
      setw -g window-status-format "#[fg=#${c.base01},bg=#${c.base01},nobold,nounderscore,noitalics]#[fg=#${c.base05}] #I  #W #[fg=#${c.base01},bg=#${c.base01},nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#${c.base01},bg=#${c.base02},nobold,nounderscore,noitalics]#[fg=#${c.base05},bg=#${c.base02}] #I  #W  #F #[fg=#${c.base02},bg=#${c.base01},nobold,nounderscore,noitalics]"
    '';
  };
}
