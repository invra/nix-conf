{
  pkgs,
  ...
}:
{
  programs.vscode = with pkgs; {
    package = vscode;
    enable = true;
  };
}
