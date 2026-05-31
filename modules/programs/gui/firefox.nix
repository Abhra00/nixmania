{
  flake.modules.nixos.gui_firefox = {
    config,
    inputs,
    pkgs,
    ...
  }: {
    hm.programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      configPath = "${config.hm.xdg.configHome}/mozilla/firefox";

      languagePacks = ["en-US" "hi-IN" "en-GB"];

      profiles.dev-edition-default = {
        id = 0;
        isDefault = true;

        settings = {
          # Auto-enable nix store extensions
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 15;
          "extensions.startupScanScopes" = 15;

          # Betterfox 149.0 | Fastfox
          "gfx.content.skia-font-cache-size" = 32;
          "gfx.webrender.layer-compositor" = true;
          "gfx.canvas.accelerated.cache-items" = 32768;
          "gfx.canvas.accelerated.cache-size" = 256;
          "browser.cache.disk.enable" = false;
          "media.memory_cache_max_size" = 65536;

          # Speculative loading
          "network.http.speculative-parallel-limit" = 0;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.places.speculativeConnect.enabled" = false;
          "network.prefetch-next" = false;

          # Betterfox 149.0 | Securefox — tracking protection
          "browser.contentblocking.category" = "strict";
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.uitour.enabled" = false;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.antitracking.isolateContentScriptResources" = true;

          # OCSP and certs
          "security.OCSP.enabled" = 0;
          "security.csp.reporting.enabled" = false;

          # SSL/TLS
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "security.tls.enable_0rtt_data" = false;

          # Disk avoidance
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "browser.sessionstore.interval" = 60000;

          # Shutdown and sanitizing
          "privacy.history.custom" = true;
          "browser.privatebrowsing.resetPBM.enabled" = true;

          # Search and URL bar
          "browser.urlbar.trimHttps" = true;
          "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.formfill.enable" = false;
          "network.IDN_show_punycode" = true;

          # HTTPS-only mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_error_page_user_suggestions" = true;

          # Passwords
          "signon.formlessCapture.enabled" = false;
          "signon.privateBrowsingCapture.enabled" = false;
          "network.auth.subresource-http-auth-allow" = 1;
          "editor.truncate_user_pastes" = false;

          # Headers and referers
          "network.http.referer.XOriginTrimmingPolicy" = 2;

          # Containers
          "privacy.userContext.ui.enabled" = true;

          # PDF and safe browsing
          "pdfjs.enableScripting" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;

          # Permissions and geolocation
          "permissions.default.desktop-notification" = 2;
          "permissions.default.geo" = 2;
          "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
          "browser.search.update" = false;
          "permissions.manager.defaultsUrl" = "";
          "extensions.getAddons.cache.enabled" = false;

          # Telemetry
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

          # Experiments
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";

          # Crash reports
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;

          # Betterfox 149.0 | Peskyfox — Mozilla UI cleanup
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

          # Theme
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.compactmode.show" = true;
          "browser.privateWindowSeparation.enabled" = false;

          # AI features
          "browser.ai.control.default" = "blocked";
          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.ml.chat.menu" = false;
          "browser.tabs.groups.smart.enabled" = false;
          "browser.ml.linkPreview.enabled" = false;

          # Fullscreen notice
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";
          "full-screen-api.warning.timeout" = 0;

          # URL bar
          "browser.urlbar.trending.featureGate" = false;

          # New tab page
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;

          # Downloads
          "browser.download.manager.addToRecentDocs" = false;
          "browser.download.open_pdf_attachments_inline" = true;

          # Tab behavior
          "browser.bookmarks.openInTabClosesMenu" = false;
          "browser.menu.showViewImageInfo" = true;
          "findbar.highlightAll" = true;
          "layout.word_select.eat_space_to_next_word" = false;

          # Smoothfox — Natural Smooth Scrolling V3
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

        extensions = {
          force = true;
          packages = with inputs.firefox-addons.packages."x86_64-linux"; [
            auto-tab-discard
            darkreader
            privacy-badger
            return-youtube-dislikes
            sponsorblock
            ublock-origin
          ];
        };
      };
    };
  };
}
