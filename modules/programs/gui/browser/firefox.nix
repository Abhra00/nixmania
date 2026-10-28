{
  flake.modules.nixos.gui_firefox = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

    smoothfox = "smooth";

    mkEngine = alias: url: {
      urls = [{template = url;}];
      definedAliases = [alias];
    };

    mkNixEngine = alias: page:
      mkEngine alias "https://search.nixos.org/${page}?channel=unstable&query={searchTerms}";

    fastfox = {
      "gfx.content.skia-font-cache-size" = 20;
      "content.notify.interval" = 100000;
      "gfx.canvas.accelerated.cache-size" = 512;
      "media.cache_readahead_limit" = 3600;
      "media.cache_resume_threshold" = 1800;
      "image.mem.decode_bytes_at_a_time" = 32768;
      "network.buffer.cache.size" = 65535;
      "network.buffer.cache.count" = 48;
      "network.http.max-connections" = 1800;
      "network.http.max-persistent-connections-per-server" = 10;
      "network.http.max-urgent-start-excessive-connections-per-host" = 5;
      "network.http.request.max-start-delay" = 5;
      "network.dnsCacheExpiration" = 3600;
    };

    securefox = {
      "browser.contentblocking.category" = "strict";
      "browser.download.start_downloads_in_tmp_dir" = true;
      "browser.uitour.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = true;
      "security.OCSP.enabled" = 0;
      "privacy.antitracking.isolateContentScriptResources" = true;
      "security.csp.reporting.enabled" = false;
      "security.ssl.treat_unsafe_negotiation_as_broken" = true;
      "browser.xul.error_pages.expert_bad_cert" = true;
      "security.tls.enable_0rtt_data" = false;
      "browser.cache.disk.enable" = false;
      "browser.privatebrowsing.forceMediaMemoryCache" = true;
      "media.memory_cache_max_size" = 65536;
      "browser.sessionstore.interval" = 60000;
      "privacy.history.custom" = true;
      "network.http.speculative-parallel-limit" = 0;
      "network.dns.disablePrefetch" = true;
      "network.dns.disablePrefetchFromHTTPS" = true;
      "browser.urlbar.speculativeConnect.enabled" = false;
      "browser.places.speculativeConnect.enabled" = false;
      "network.prefetch-next" = false;
      "browser.urlbar.trimHttps" = true;
      "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
      "browser.search.separatePrivateDefault.ui.enabled" = true;
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.groupLabels.enabled" = false;
      "browser.formfill.enable" = false;
      "network.IDN_show_punycode" = true;
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_error_page_user_suggestions" = true;
      "signon.formlessCapture.enabled" = false;
      "signon.privateBrowsingCapture.enabled" = false;
      "network.auth.subresource-http-auth-allow" = 1;
      "editor.truncate_user_pastes" = false;
      "network.http.referer.XOriginTrimmingPolicy" = 2;
      "pdfjs.enableScripting" = false;
      "browser.safebrowsing.downloads.remote.enabled" = false;
      "permissions.default.desktop-notification" = 2;
      "permissions.default.geo" = 2;
      "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
      "browser.search.update" = false;
      "permissions.manager.defaultsUrl" = "";
      "extensions.getAddons.cache.enabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "datareporting.usage.uploadEnabled" = false;
      "app.shield.optoutstudies.enabled" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";
      "nimbus.rollouts.enabled" = false;
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;
      "browser.crashReports.unsubmittedCheck.enabled" = false;
    };

    peskyfox = {
      "full-screen-api.warning.timeout" = 0;
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "browser.discovery.enabled" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "browser.preferences.moreFromMozilla" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.startup.homepage_override.mstone" = "ignore";
      "browser.aboutwelcome.enabled" = false;
      "browser.profiles.enabled" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.compactmode.show" = true;
      "layout.css.prefers-color-scheme.content-override" = 2;
      "browser.privateWindowSeparation.enabled" = false;
      "browser.ai.control.default" = "blocked";
      "browser.ml.enable" = false;
      "browser.tabs.groups.smart.enabled" = false;
      "browser.ml.linkPreview.enabled" = false;
      "browser.ml.chat.enabled" = false;
      "browser.ml.chat.menu" = false;
      "full-screen-api.transition-duration.enter" = "0 0";
      "full-screen-api.transition-duration.leave" = "0 0";
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.trending.featureGate" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
      "browser.newtabpage.activity-stream.default.sites" = "";
      "browser.download.manager.addToRecentDocs" = false;
      "browser.download.open_pdf_attachments_inline" = true;
      "browser.bookmarks.openInTabClosesMenu" = false;
      "findbar.highlightAll" = true;
    };

    smoothfoxOptions = {
      sharpen = {
        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "mousewheel.min_line_scroll_amount" = 10;
        "general.smoothScroll.mouseWheel.durationMinMS" = 80;
        "general.smoothScroll.currentVelocityWeighting" = "0.15";
        "general.smoothScroll.stopDecelerationWeighting" = "0.6";
        "general.smoothScroll.msdPhysics.enabled" = false;
      };
      instant = {
        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "mousewheel.default.delta_multiplier_y" = 275;
        "general.smoothScroll.msdPhysics.enabled" = false;
      };
      smooth = {
        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "mousewheel.default.delta_multiplier_y" = 300;
      };
      zen = {
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.currentVelocityWeighting" = "0.15";
        "general.smoothScroll.stopDecelerationWeighting" = "0.6";
        "mousewheel.min_line_scroll_amount" = 10;
        "general.smoothScroll.mouseWheel.durationMinMS" = 80;
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "mousewheel.default.delta_multiplier_y" = 200;
      };
      natural = {
        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "general.smoothScroll.currentVelocityWeighting" = "1";
        "general.smoothScroll.stopDecelerationWeighting" = "1";
        "mousewheel.default.delta_multiplier_y" = 300;
      };
    };

    startPage = {
      "browser.startup.page" = 1;
      "browser.startup.homepage" = "about:home";
      "browser.newtabpage.enabled" = true;
      "browser.newtabpage.activity-stream.showSearch" = true;
      "browser.newtabpage.activity-stream.logowordmark.alwaysVisible" = true;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.snippets" = false;
      "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.showWeather" = false;
      "browser.newtabpage.activity-stream.system.showWeather" = false;
      "browser.newtabpage.activity-stream.newtabWallpapers.enabled" = false;
      "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = false;
      "browser.newtabpage.activity-stream.widgets.system.enabled" = false;
      "browser.newtabpage.activity-stream.widgets.lists.enabled" = false;
      "browser.newtabpage.activity-stream.widgets.focusTimer.enabled" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
    };

    devtools = {
      "devtools.chrome.enabled" = true;
      "devtools.debugger.remote-enabled" = true;
      "devtools.theme" = "dark";
      "devtools.toolbox.host" = "right";
      "devtools.editor.keymap" = "vim";
      "devtools.cache.disabled" = true;
      "devtools.netmonitor.persistlog" = true;
      "devtools.webconsole.persistlog" = true;
      "devtools.inspector.showAllAnonymousContent" = true;
      "devtools.command-button-measure.enabled" = true;
      "devtools.command-button-rulers.enabled" = true;
      "devtools.command-button-screenshot.enabled" = true;
    };

    extensionScopes = {
      "extensions.autoDisableScopes" = 0;
      "extensions.enabledScopes" = 15;
      "extensions.startupScanScopes" = 15;
    };

    misc = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "privacy.fingerprintingProtection" = true;
    };
  in {
    hm = lib.mkMerge [
      {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox;

          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableFormHistory = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;

            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;

            Homepage = {
              URL = "about:home";
              StartPage = "homepage";
            };

            EnableTrackingProtection = {
              Value = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            FirefoxSuggest = {
              WebSuggestions = false;
              SponsoredSuggestions = false;
              ImproveSuggest = false;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              FeatureRecommendations = false;
              MoreFromMozilla = false;
              UrlbarInterventions = false;
            };
          };

          profiles.default = {
            isDefault = true;

            settings =
              fastfox
              // securefox
              // peskyfox
              // smoothfoxOptions.${smoothfox}
              // startPage
              // devtools
              // extensionScopes
              // misc;

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

                "Arch Wiki" = mkEngine "@aw" "https://wiki.archlinux.org/index.php?search={searchTerms}";
                "crates.io" = mkEngine "@crates" "https://crates.io/search?q={searchTerms}";
                "docs.rs" = mkEngine "@rs" "https://docs.rs/releases/search?query={searchTerms}";
                "GitHub" = mkEngine "@gh" "https://github.com/search?q={searchTerms}";
                "Home Manager Options" = mkEngine "@hm" "https://home-manager-options.extranix.com/?query={searchTerms}";
                "MDN" = mkEngine "@mdn" "https://developer.mozilla.org/en-US/search?q={searchTerms}";
                "Nix Options" = mkNixEngine "@no" "options";
                "Nix Packages" = mkNixEngine "@np" "packages";
                "npm" = mkEngine "@npm" "https://www.npmjs.com/search?q={searchTerms}";
                "youtube" = mkEngine "@yt" "https://www.youtube.com/results?search_query={searchTerms}";
              };
            };

            userContent = ''
              * { scrollbar-width: thin !important; }
            '';
          };
        };
      }

      (import ./_tridactyl.nix {inherit config lib pkgs addons;})
    ];
  };
}
