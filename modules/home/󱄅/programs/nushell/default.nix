{
  pkgs,
  lib,
  config,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

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
