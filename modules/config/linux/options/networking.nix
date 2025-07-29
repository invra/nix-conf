{
  pkgs,
  configTOML,
  ...
}:
{
  networking = with configTOML.system; {
    hostName = hostname;
    networkmanager.enable = networking.networkmanager;
    firewall.enable = networking.firewallEnabled;
    useDHCP = pkgs.lib.mkForce networking.dhcpEnabled;

    interfaces = builtins.listToAttrs (
      map (iface: {
        name = iface.name;
        value.useDHCP = (iface.dhcpEnabled or iface.type != "BRIDGE");
      }) networking.interfaces or [ ]
    );

    bridges = builtins.listToAttrs (
      map (iface: {
        name = iface.name;
        value.interfaces = (iface.interfaces or [ ]);
      }) (builtins.filter (iface: iface.type == "BRIDGE") networking.interfaces or [ ])
    );
  };
}
