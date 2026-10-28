{
  config,
  lib,
  pkgs,
  addons,
}: let
  c = config.lib.stylix.colors.withHashtag;

  font = config.stylix.fonts.monospace.name;
  size = "${toString config.stylix.fonts.sizes.applications}pt";

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

  theme = ''
    :root {
      --base00: ${c.base00};
      --base01: ${c.base01};
      --base02: ${c.base02};
      --base03: ${c.base03};
      --base04: ${c.base04};
      --base05: ${c.base05};
      --base06: ${c.base06};
      --base07: ${c.base07};
      --base08: ${c.base08};
      --base09: ${c.base09};
      --base0A: ${c.base0A};
      --base0B: ${c.base0B};
      --base0C: ${c.base0C};
      --base0D: ${c.base0D};
      --base0E: ${c.base0E};
      --base0F: ${c.base0F};

      --tridactyl-fg: var(--base05);
      --tridactyl-bg: var(--base00);
      --tridactyl-url-fg: var(--base08);
      --tridactyl-url-bg: var(--base00);
      --tridactyl-highlight-box-bg: var(--base0B);
      --tridactyl-highlight-box-fg: var(--base00);

      --tridactyl-hintspan-fg: var(--base00) !important;
      --tridactyl-hintspan-bg: var(--base0A) !important;

      --tridactyl-hint-active-fg: none;
      --tridactyl-hint-active-bg: none;
      --tridactyl-hint-active-outline: none;
      --tridactyl-hint-bg: none;
      --tridactyl-hint-outline: none;
    }

    #command-line-holder {
      order: 1;
      border: 2px solid var(--base0B);
      color: var(--tridactyl-bg);
    }

    #tridactyl-input {
      color: var(--tridactyl-fg);
      width: 90%;
      font-family: "${font}", monospace;
      font-size: ${size};
      line-height: 1.5;
      background: var(--tridactyl-bg);
      padding: 1rem;
    }

    #completions {
      --option-height: 1.4em;
      color: var(--tridactyl-fg);
      background: var(--tridactyl-bg);
      display: inline-block;
      font-family: "${font}", monospace;
      font-size: ${size};
      font-weight: 500;
      overflow: hidden;
      width: 100%;
      border-top: unset;
      order: 2;
    }

    #completions > div {
      max-height: calc(20 * var(--option-height));
      min-height: calc(10 * var(--option-height));
    }

    #completions table {
      font-size: ${size};
      font-weight: 400;
      border-spacing: 0;
      table-layout: fixed;
      padding: 1rem;
    }

    #completions .HistoryCompletionSource,
    #completions .BmarkCompletionSource {
      max-height: unset;
      min-height: unset;
    }

    #completions .HistoryCompletionSource table {
      width: 100%;
      font-size: ${size};
      border-spacing: 0;
      table-layout: fixed;
    }

    #completions .BufferCompletionSource table {
      width: unset;
      font-size: ${size};
      border-spacing: unset;
      table-layout: unset;
    }

    #completions table tr td.prefix,
    #completions table tr td.privatewindow,
    #completions table tr td.container,
    #completions table tr td.icon {
      display: none;
    }

    #completions table tr .title {
      width: 50%;
    }

    #completions table tr {
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    #completions .sectionHeader {
      background: unset;
      font-weight: 500;
      border-bottom: unset;
      padding: 1rem !important;
      padding-left: unset;
      padding-bottom: 0.2rem;
    }

    #completions .focused,
    #completions .focused .url {
      background: var(--base0B);
      color: var(--base00);
    }

    .TridactylStatusIndicator {
      position: fixed !important;
      bottom: 0 !important;
      background: var(--tridactyl-bg) !important;
      border: 1px var(--base0B) solid !important;
      font-family: "${font}", monospace !important;
      font-size: ${size} !important;
      padding: 0.8ex !important;
    }
  '';
in {
  programs.firefox = {
    nativeMessagingHosts = [pkgs.tridactyl-native];
    profiles.default.extensions.packages = [addons.tridactyl];
  };

  xdg.configFile."tridactyl/themes/stylix.css".text = theme;

  xdg.configFile."tridactyl/tridactylrc".text = ''
    colourscheme stylix

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
