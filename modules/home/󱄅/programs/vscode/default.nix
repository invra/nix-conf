{ unstable, ... }:
let
  pkgs = unstable;
in
{
  programs.vscode = {
    package = pkgs.vscode;
    enable = true;
  }; 
}