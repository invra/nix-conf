{ unstable, ... }:
{
  programs.vscode = {
    enable = true;
    package = unstable.vscode.fhs;
    profiles.default.extensions = with unstable.vscode-extensions; [
      pkief.material-icon-theme
      bradlc.vscode-tailwindcss
      vscodevim.vim
      ms-vsliveshare.vsliveshare
      ms-vscode.live-server
      kamikillerto.vscode-colorize
      bierner.github-markdown-preview
      mvllow.rose-pine
    ];
  };
}
