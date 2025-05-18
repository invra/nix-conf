{
  unstable,
  lib,
  config,
  ...
}:

let
  isDarwin = unstable.stdenv.isDarwin;
  isLinux = unstable.stdenv.isLinux;

  configPath = if isDarwin then ./config/darwin.nu else ./config/linux.nu;
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
