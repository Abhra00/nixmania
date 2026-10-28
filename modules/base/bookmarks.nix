{
  flake.modules.nixos.base = {...}: {
    hm = {config, ...}: let
      dirs = config.xdg.userDirs;
    in {
      gtk.gtk3.bookmarks = map (dir: "file://${dir}") [
        dirs.desktop
        dirs.documents
        dirs.download
        dirs.music
        dirs.pictures
        dirs.projects
        dirs.videos
      ];
    };
  };
}
