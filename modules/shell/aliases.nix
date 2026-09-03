{
  flake.modules.nixos.shell_aliases = {confDir, ...}: let
    userAliases = {
      # cargo
      cb = "cargo build";
      cbr = "cargo build --release";
      cc = "cargo check";
      cr = "cargo run";
      crr = "cargo run --release";
      ct = "cargo test";
      # eza
      ls = "eza -lh --icons --group";
      la = "eza -lah --icons --group";
      lat = "eza -lahT --icons --group";
      lt = "eza -lhT --icons --group";
      # git
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gcl = "git clone";
      gcm = "git commit -m";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";
      gp = "git push";
      gpl = "git pull";
      grb = "git rebase";
      grs = "git restore";
      gs = "git status";
      gst = "git stash";
      gstp = "git stash pop";
      gsts = "git stash show";
      # general
      ff = "fastfetch";
      rmf = "rm -rf";
      cp = "cp -i";
      mv = "mv -i";
      mkdir = "mkdir -p";
      ytm = ''yt-dlp -x --audio-quality 0 --embed-thumbnail --convert-thumbnails jpg --embed-metadata --parse-metadata "playlist_index:%(track_number)s" --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=ih" -o "~/Music/%(playlist_title,title)s/%(playlist_index&{:02d}. |)s%(title)s.%(ext)s"'';
    };

    systemAliases = {
      # cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      cf = "cd ${confDir}";
      # nix
      nos = "nh os switch .";
      nup = "nix flake update";
      nsh = "nix shell --impure";
      nrn = "nix run nixpkgs#";
      nflc = "nix flake check";
      # systemd
      sc = "systemctl";
      scs = "systemctl status";
      scr = "systemctl restart";
      sce = "systemctl enable";
      scd = "systemctl disable";
      scu = "systemctl --user";
      scus = "systemctl --user status";
      scur = "systemctl --user restart";
      jl = "journalctl";
      jlf = "journalctl -f";
      jlu = "journalctl -u";
      jlfu = "journalctl -fu";
    };
  in {
    environment.shellAliases = systemAliases;
    hm.programs.bash.shellAliases = userAliases // systemAliases;
  };
}
