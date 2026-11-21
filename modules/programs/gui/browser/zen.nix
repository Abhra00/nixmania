{
  flake.modules.nixos.gui_zen = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

    mkEngine = alias: url: {
      urls = [{template = url;}];
      definedAliases = [alias];
    };

    mkNixEngine = alias: page:
      mkEngine alias "https://search.nixos.org/${page}?channel=unstable&query={searchTerms}";

    ui = {
      "zen.welcome-screen.seen" = true;
      "zen.workspaces.continue-where-left-off" = true;
      "zen.urlbar.behavior" = "float";
      "zen.view.use-single-toolbar" = true;
      "zen.view.compact.hide-tabbar" = true;
      "zen.view.compact.toolbar-flash-popup" = true;
      "zen.view.experimental-no-window-controls" = true;
      "zen.theme.content-element-separation" = 0;
      "zen.watermark.enabled" = false;
      "browser.tabs.hoverPreview.enabled" = false;
      "browser.download.alwaysOpenPanel" = false;
    };

    hardening = {
      "privacy.fingerprintingProtection" = true;
      "privacy.fingerprintingProtection.pbmode" = true;
      "privacy.query_stripping.enabled" = true;
      "privacy.query_stripping.enabled.pbmode" = true;
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "network.cookie.cookieBehavior" = 5;
      "network.proxy.allow_bypass" = false;
      "network.captive-portal-service.enabled" = false;
      "network.connectivity-service.enabled" = false;
      "network.dns.echconfig.enabled" = true;
      "network.dns.http3_echconfig.enabled" = true;
      "media.peerconnection.ice.default_address_only" = true;
      "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
      "dom.security.https_only_mode_pbm" = true;
      "dom.private-attribution.submission.enabled" = false;
      "security.mixed_content.block_display_content" = true;
      "security.ssl.require_safe_negotiation" = true;
      "security.pki.crlite_mode" = 2;
      "browser.send_pings" = false;
      "beacon.enabled" = false;
      "identity.fxaccounts.enabled" = false;
      "webchannel.allowObject.urlWhitelist" = "";
    };

    devtools = {
      "devtools.chrome.enabled" = true;
      "devtools.debugger.remote-enabled" = true;
      "devtools.debugger.prompt-connection" = true;
      "devtools.theme" = "auto";
      "devtools.toolbox.host" = "right";
      "devtools.editor.keymap" = "vim";
      "devtools.cache.disabled" = true;
      "devtools.accessibility.enabled" = true;
      "devtools.inspector.showAllAnonymousContent" = true;
      "devtools.netmonitor.persistlog" = true;
      "devtools.netmonitor.responseBodyLimit" = 10485760;
      "devtools.webconsole.persistlog" = true;
      "devtools.webconsole.timestampMessages" = true;
      "devtools.webconsole.input.editor" = true;
      "devtools.webconsole.input.context" = true;
      "devtools.debugger.map-scopes-enabled" = true;
      "devtools.debugger.features.async-live-stacks" = true;
      "devtools.debugger.ui.editor-wrapping" = true;
      "devtools.screenshot.clipboard.enabled" = true;
      "devtools.screenshot.audio.enabled" = false;
      "devtools.command-button-measure.enabled" = true;
      "devtools.command-button-rulers.enabled" = true;
      "devtools.command-button-screenshot.enabled" = true;
    };

    nixExtensionScopes = {
      "extensions.autoDisableScopes" = 0;
      "extensions.enabledScopes" = 15;
      "extensions.startupScanScopes" = 15;
    };
  in {
    home-manager.sharedModules = [inputs.zen-browser.homeModules.beta];

    hm = lib.mkMerge [
      {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;

          policies = {
            DisableAppUpdate = true;
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableFormHistory = true;
            DisableFeedbackCommands = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;
            HttpsOnlyMode = "force_enabled";

            DNSOverHTTPS = {
              Enabled = true;
              ProviderURL = "https://dns.quad9.net/dns-query";
              Locked = true;
              Fallback = true;
            };

            SanitizeOnShutdown = {
              Cache = true;
              Cookies = true;
              Downloads = true;
              FormData = true;
              History = true;
              Sessions = true;
              OfflineApps = true;
              SiteSettings = false;
              Locked = true;
            };

            Cookies.Allow = [
              "https://accounts.google.com"
              "https://claude.ai"
              "https://discord.com/"
              "https://github.com"
              "https://google.com"
            ];

            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
              EmailTracking = true;
            };

            UserMessaging = {
              ExtensionRecommendations = false;
              FeatureRecommendations = false;
              MoreFromMozilla = false;
              UrlbarInterventions = false;
            };

            "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite.filterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "easyprivacy"
              "urlhaus-1"
              "adguard-spyware-url"
            ];
          };

          profiles.default = {
            isDefault = true;
            presets.betterfox.enable = true;

            settings =
              ui
              // hardening
              // devtools
              // nixExtensionScopes
              // {
                "widget.use-xdg-desktop-portal.file-picker" = 1;
                "widget.use-xdg-desktop-portal.mime-handler" = 1;
                "browser.ai.control.default" = "blocked";
              };

            extensions = {
              force = true;
              packages = with addons; [
                darkreader
                react-devtools
                sponsorblock
                ublock-origin
              ];
            };

            search = {
              force = true;
              default = "ddg";
              privateDefault = "ddg";
              engines = {
                "google".metaData.hidden = true;
                "bing".metaData.hidden = true;
                "crates.io" = mkEngine "@crates" "https://crates.io/search?q={searchTerms}";
                "docs.rs" = mkEngine "@rs" "https://docs.rs/releases/search?query={searchTerms}";
                "GitHub" = mkEngine "@gh" "https://github.com/search?q={searchTerms}";
                "MDN" = mkEngine "@mdn" "https://developer.mozilla.org/en-US/search?q={searchTerms}";
                "Nix Options" = mkNixEngine "@no" "options";
                "Nix Packages" = mkNixEngine "@np" "packages";
                "npm" = mkEngine "@npm" "https://www.npmjs.com/search?q={searchTerms}";
                "youtube" = mkEngine "@yt" "https://www.youtube.com/results?search_query={searchTerms}";
              };
            };

            spaces = {
              "Dev" = {
                id = "43e682a2-53a5-4bbe-a413-8ad0dbe40ac1";
                position = 1000;
                icon = "💻";
              };
              "Media" = {
                id = "c757e460-02e3-4b56-b828-56e9784a61b1";
                position = 2000;
                icon = "🎧";
              };
            };

            pins = {
              "GitHub" = {
                id = "022a2381-f07b-4e0d-b54d-40aaaf9a44a0";
                url = "https://github.com/Abhra00";
                position = 101;
              };
              "Nix Packages" = {
                id = "53f6888c-b693-4acf-abe0-36d5cf3b9725";
                url = "https://search.nixos.org/packages";
                position = 102;
              };
            };
          };
        };
      }
      (import ./_tridactyl.nix {inherit config lib pkgs addons;})
    ];
  };
}
