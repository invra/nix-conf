{ ... }:
{
  imports = [
    ./starship
    ./carpace
    ./zoxide
  ];
  programs.nushell = {
    enable = true;
    configFile.source = ./system/config/nushell/config.nu;
  };
}
