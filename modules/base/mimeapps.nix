{
  flake.modules.nixos.base = {
    hm.xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Video
        "video/mp4" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/mp2t" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/vnd.avi" = "mpv.desktop";
        "video/x-ms-wmv" = "mpv.desktop";
        "video/x-flv" = "mpv.desktop";
        "video/x-flic" = "mpv.desktop";
        "video/x-ogm+ogg" = "mpv.desktop";
        "video/x-theora+ogg" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/dv" = "mpv.desktop";
        "video/3gpp" = "mpv.desktop";
        "video/3gpp2" = "mpv.desktop";
        "video/vnd.rn-realvideo" = "mpv.desktop";
        "video/vnd.mpegurl" = "mpv.desktop";
        "video/mpegurl" = "mpv.desktop";

        # Audio
        "audio/mpeg" = "mpv.desktop";
        "audio/mp2" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/aac" = "mpv.desktop";
        "audio/ac3" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/webm" = "mpv.desktop";
        "audio/x-wavpack" = "mpv.desktop";
        "audio/x-vorbis+ogg" = "mpv.desktop";
        "audio/x-matroska" = "mpv.desktop";
        "audio/x-ape" = "mpv.desktop";
        "audio/x-tta" = "mpv.desktop";
        "audio/x-musepack" = "mpv.desktop";
        "audio/x-adpcm" = "mpv.desktop";
        "audio/x-aiff" = "mpv.desktop";
        "audio/x-ms-wma" = "mpv.desktop";
        "audio/vnd.wave" = "mpv.desktop";
        "audio/vnd.dts" = "mpv.desktop";
        "audio/vnd.dts.hd" = "mpv.desktop";
        "audio/vnd.rn-realaudio" = "mpv.desktop";
        "audio/amr" = "mpv.desktop";
        "audio/x-mpegurl" = "mpv.desktop";
        "audio/mpegurl" = "mpv.desktop";
        "audio/x-ms-asx" = "mpv.desktop";
        "audio/x-scpls" = "mpv.desktop";

        # Media applications
        "application/vnd.apple.mpegurl" = "mpv.desktop";
        "application/x-mpegURL" = "mpv.desktop";
        "application/vnd.ms-asf" = "mpv.desktop";
        "application/vnd.rn-realmedia" = "mpv.desktop";
        "application/ogg" = "mpv.desktop";
        "application/smil+xml" = "mpv.desktop";
        "application/sdp" = "mpv.desktop";
        "application/mxf" = "mpv.desktop";
        "application/x-matroska" = "mpv.desktop";
        "application/x-cue" = "mpv.desktop";
        "application/x-shorten" = "mpv.desktop";

        # Images
        "image/png" = "org.gnome.eog.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
        "image/gif" = "org.gnome.eog.desktop";
        "image/webp" = "org.gnome.eog.desktop";
        "image/bmp" = "org.gnome.eog.desktop";
        "image/tiff" = "org.gnome.eog.desktop";
        "image/svg+xml" = "org.gnome.eog.desktop";
        "image/heif" = "org.gnome.eog.desktop";
        "image/x-xbitmap" = "org.gnome.eog.desktop";
        "image/x-portable-bitmap" = "org.gnome.eog.desktop";
        "image/x-portable-graymap" = "org.gnome.eog.desktop";
        "image/x-portable-pixmap" = "org.gnome.eog.desktop";
        "image/x-portable-anymap" = "org.gnome.eog.desktop";
        "image/x-tga" = "org.gnome.eog.desktop";
        "image/vnd.zbrush.pcx" = "org.gnome.eog.desktop";

        # PDF / documents
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/epub+zip" = "org.pwmt.zathura.desktop";
        "application/vnd.comicbook+zip" = "org.pwmt.zathura.desktop";
        "application/oxps" = "org.pwmt.zathura.desktop";
        "application/vnd.ms-xpsdocument" = "org.pwmt.zathura.desktop";
        "application/x-fictionbook+xml" = "org.pwmt.zathura-pdf-mupdf.desktop";

        # Text / code
        "text/plain" = "Helix.desktop";
        "text/x-shellscript" = "Helix.desktop";
        "application/x-shellscript" = "Helix.desktop";
        "text/x-csrc" = "Helix.desktop";
        "text/x-c++src" = "Helix.desktop";
        "text/x-chdr" = "Helix.desktop";
        "text/x-c++hdr" = "Helix.desktop";
        "text/x-makefile" = "Helix.desktop";
        "text/x-python" = "Helix.desktop";
        "text/x-python3" = "Helix.desktop";
        "text/rust" = "Helix.desktop";
        "text/javascript" = "Helix.desktop";
        "application/javascript" = "Helix.desktop";
        "text/html" = "Helix.desktop";
        "text/css" = "Helix.desktop";
        "application/json" = "Helix.desktop";
        "application/xml" = "Helix.desktop";
        "text/xml" = "Helix.desktop";
        "application/sql" = "Helix.desktop";
        "application/toml" = "Helix.desktop";
        "application/yaml" = "Helix.desktop";
        "text/x-yaml" = "Helix.desktop";
        "text/markdown" = "Helix.desktop";
        "text/x-nix" = "Helix.desktop";
      };
    };
  };
}
