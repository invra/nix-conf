{
  unstable,
  ...
}:
{
  imports = [
    ./starship
    ./carpace
    ./zoxide
  ];

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
  };
}
