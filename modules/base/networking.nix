{
  flake.modules.nixos.base = {...}: {
    networking = {
      networkmanager.enable = false;
      useNetworkd = true;
      useDHCP = false;

      wireless.iwd = {
        enable = true;
        settings = {
          General.EnableNetworkConfiguration = false;
        };
      };

      nftables.enable = true;
    };

    systemd.network = {
      enable = true;
      networks = {
        "10-wlan" = {
          matchConfig.Type = "wlan";
          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
          };
        };
        "10-eth" = {
          matchConfig.Name = "en*";
          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
          };
          dhcpV4Config.RouteMetric = 100;
        };
        "40-libvirt" = {
          matchConfig.Name = "virbr*";
          linkConfig.Unmanaged = true;
        };
      };
    };

    services.resolved = {
      enable = true;
      settings.Resolve.FallbackDNS = ["1.1.1.1" "9.9.9.9"];
    };

    networking.firewall = {
      enable = true;
      trustedInterfaces = ["virbr0"];
    };
  };
}
