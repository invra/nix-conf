{
  lib,
  pkgs,
  linux,
  flakeConfig,
  ...
}:
{
  networking = lib.optionalAttrs linux (
    with flakeConfig.system;
    {
      hostName = hostname;
      networkmanager.enable = networking.networkmanager;
      firewall.enable = networking.firewallEnabled;
      useDHCP = pkgs.lib.mkForce networking.dhcpEnabled;

      interfaces = listToAttrs (
        map (iface: {
          name = iface.name;
          value.useDHCP =
            !(any (br: elem iface.name (br.interfaces or [ ])) (
              filter (br: br.type == "BRIDGE") (networking.interfaces or [ ])
            ))
            && (iface.dhcpEnabled or iface.type != "BRIDGE");
        }) (networking.interfaces or [ ])
      );

      bridges = listToAttrs (
        map (iface: {
          name = iface.name;
          value.interfaces = (iface.interfaces or [ ]);
        }) (filter (iface: iface.type == "BRIDGE") networking.interfaces or [ ])
      );
    }
  );
}
