{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    license-go
  ];
}
