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
        "text/plain" = "nvim.desktop";
        "text/x-shellscript" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "text/x-csrc" = "nvim.desktop";
        "text/x-c++src" = "nvim.desktop";
        "text/x-chdr" = "nvim.desktop";
        "text/x-c++hdr" = "nvim.desktop";
        "text/x-makefile" = "nvim.desktop";
        "text/x-python" = "nvim.desktop";
        "text/x-python3" = "nvim.desktop";
        "text/rust" = "nvim.desktop";
        "text/javascript" = "nvim.desktop";
        "application/javascript" = "nvim.desktop";
        "text/html" = "nvim.desktop";
        "text/css" = "nvim.desktop";
        "application/json" = "nvim.desktop";
        "application/xml" = "nvim.desktop";
        "text/xml" = "nvim.desktop";
        "application/sql" = "nvim.desktop";
        "application/toml" = "nvim.desktop";
        "application/yaml" = "nvim.desktop";
        "text/x-yaml" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";
        "text/x-nix" = "nvim.desktop";

        # File manager
        "inode/directory" = "yazi.desktop";
      };
    };
    hm.xdg.terminal-exec = {
      enable = true;
      settings = {
        default = ["com.mitchellh.ghostty.desktop"];
      };
    };
  };
}
