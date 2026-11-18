{
  flake.modules.nixos.security_tpm = {pkgs, ...}: {
    environment.systemPackages = [pkgs.age-plugin-tpm pkgs.tpm2-tools];
    security.tpm2.enable = true;
  };
}
