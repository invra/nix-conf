{ unstable, ... }:
{
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    package = unstable.vscode.fhs;
    profiles.default = {
      userSettings = {
        "chat.editor.fontFamily" = "JetBrains Mono Nerd Font";
        "chat.editor.fontSize" = 14.0;
        "debug.console.fontFamily" = "JetBrains Mono Nerd Font";
        "debug.console.fontSize" = 14.0;
        "editor.fontFamily" = "JetBrains Mono Nerd Font";
        "editor.fontSize" = 14;
        "editor.inlayHints.fontFamily" = "JetBrains Mono Nerd Font";
        "editor.inlineSuggest.fontFamily" = "JetBrains Mono Nerd Font";
        "editor.minimap.sectionHeaderFontSize" = 10;
        "markdown.preview.fontFamily" = "DejaVu Sans";
        "markdown.preview.fontSize" = 14.0;
        "scm.inputFontFamily" = "JetBrains Mono Nerd Font";
        "scm.inputFontSize" = 14;
        "screencastMode.fontSize" = 64.0;
        "terminal.integrated.fontSize" = 14.0;
        "workbench.colorTheme" = "Rosé Pine";
        "workbench.iconTheme" = "material-icon-theme";
        "window.commandCenter" = false;
        "window.menuBarVisibility" = "toggle";
        "workbench.layoutControl.enabled" = false;
        "chat.commandCenter.enabled" = false;
        "explorer.compactFolders" = false;
        "notebook.compactView" = false;
        "scm.compactFolders" = false;
        "window.titleSeparator" = " | ";
        "window.titleBarStyle" = "native";
      };

      extensions = with unstable.vscode-extensions; [
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
  };
}
