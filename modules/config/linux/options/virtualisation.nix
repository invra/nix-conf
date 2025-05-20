{ system, unstable, ... }:
{
  networking = {
    hostName = system.hostname;
    networkmanager.enable = system.networking.networkmanager;
    firewall.enable = system.networking.firewallEnabled;
    useDHCP = unstable.lib.mkForce system.networking.dhcpEnabled;

    interfaces = builtins.listToAttrs (
      map (iface: {
        name = iface.name;
        value.useDHCP = (iface.dhcpEnabled or iface.type != "BRIDGE");
      }) system.networking.interfaces or [ ]
    );

    bridges = builtins.listToAttrs (
      map (iface: {
        name = iface.name;
        value.interfaces = (iface.interfaces or [ ]);
      }) (builtins.filter (iface: iface.type == "BRIDGE") system.networking.interfaces or [ ])
    );
  };
}
