{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bandwhich
        bind # for dig
        wget
        curl
        ethtool
        gping
        inetutils
        socat
      ];
    };
}
