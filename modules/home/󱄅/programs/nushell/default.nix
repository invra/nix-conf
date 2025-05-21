{
  unstable,
  ...
}:

let
  configPath = if unstable.stdenv.isDarwin then ./config/darwin.nu else ./config/linux.nu;
in
{
  imports = [
    ./starship
    ./carpace
    ./zoxide
  ];

  programs.nushell = {
    enable = true;
    configFile.source = configPath;
  };
}
