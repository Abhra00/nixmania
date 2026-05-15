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
      l = "eza -lh --icons";
      la = "eza -lah --icons";
      lat = "eza -lahT --icons";
      lt = "eza -lhT --icons";

      # git
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gst = "git stash";

      # general
      ff = "fastfetch";
      rmf = "rm -rf";
    };
  in {
    environment.shellAliases = {
      # cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      cf = "cd ${confDir}";

      # eza
      ls = "eza --icons";

      # nix
      nos = "nh os switch .";
      nup = "nix flake update";

      # systemd
      sc = "systemctl";
      scs = "systemctl status";
      scr = "systemctl restart";
      sce = "systemctl enable";
      scd = "systemctl disable";
      jl = "journalctl";
      jlf = "journalctl -f";
      jlu = "journalctl -u";
    };
    hm.programs.bash.shellAliases = userAliases;
  };
}
