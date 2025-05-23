{ unstable, ... }:
{
  stylix.targets.helix.enable = false;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = unstable.evil-helix;

    settings = {
      theme = "rose_pine";
      editor = {
        line-number = "relative";
        scrolloff = 100;
        mouse = false;
        popup-border = "all";
        end-of-line-diagnostics = "hint";
        cursor-shape.insert = "bar";
        indent-guides.render = true;
        inline-diagnostics.cursor-line = "warning";
        insert-final-newline = false;
        lsp = {
          display-inlay-hints = true;
          display-progress-messages = true;
        };
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };
      };
    };
    extraPackages = with unstable; [
      nil
      nixd
      marksman
      bash-language-server
    ];
  };
}
