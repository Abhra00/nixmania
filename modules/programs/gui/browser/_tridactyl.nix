{
  lib,
  pkgs,
  addons,
}: let
  mediaHosts = [
    "youtube.com"
    "youtu.be"
    "twitch.tv"
    "vimeo.com"
    "dailymotion.com"
    "soundcloud.com"
    "bandcamp.com"
    "odysee.com"
    "rumble.com"
    "nebula.tv"
    "bilibili.com"
  ];

  fxMpv = pkgs.writeShellApplication {
    name = "fx-mpv";
    runtimeInputs = [pkgs.mpv pkgs.yt-dlp pkgs.util-linux];
    text = ''
      read -r url || true
      host=''${url#*://}
      host=''${host%%[/?#:]*}
      case $host in
        ${lib.concatMapStringsSep "|" (d: "${d}|*.${d}") mediaHosts}) ;;
        *)
          case ''${url%%[?#]*} in
            *.mp4|*.webm|*.mkv|*.m3u8|*.mp3|*.flac|*.opus) ;;
            *)
              noctalia msg notification-show "mpv" "Not a media site: $host"
              exit 1
              ;;
          esac
          ;;
      esac
      setsid -f mpv --force-window=immediate -- "$url" >/dev/null 2>&1 </dev/null
    '';
  };
in {
  programs.zen-browser = {
    nativeMessagingHosts = [pkgs.tridactyl-native];
    profiles.default.extensions.packages = [addons.tridactyl];
  };

  xdg.configFile."tridactyl/tridactylrc".text = ''
    set hintchars asdfghjkl
    set hintfiltermode vimperator-reflow
    set findcase smart
    set smoothscroll true

    bind gn tabopen https://search.nixos.org/packages
    bind gh tabopen https://github.com/Abhra00
    bind ,m composite js document.location.href | jsb -p tri.native.run("${lib.getExe fxMpv}", JS_ARG)
    bind ,r source
  '';
}
