{ unstable, ... }:
let
  pkgs = unstable;
in
{
  stylix.targets.helix.enable = false;

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "rose_pine";
      editor = {
        line-number = "relative";
        color-modes = true;
        bufferline = "multiple";
        scrolloff = 100;
        mouse = false;
        popup-border = "all";
        end-of-line-diagnostics = "hint";
        cursor-shape.insert = "bar";
        inline-diagnostics.cursor-line = "warning";
        insert-final-newline = false;
        statusline = {
          left = [
            "mode"
            "spinner"
          ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
            "file-type"
            "file-encoding"
            "file-line-ending"
          ];
          separator = "|";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        lsp = {
          display-inlay-hints = true;
          display-progress-messages = true;
        };
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };
        indent-guides = {
          render = true;
          character = "╎";
          skip-levels = 1;
        };
      };
    };
    extraPackages = with pkgs; [
      nil
      nixd
      marksman
      bash-language-server
    ];
  };
}
