{
  pkgs,
  treefmt-nix,
}:
let
  formatters =
    (treefmt-nix.lib.evalModule pkgs {
      projectRootFile = ".git/config";
      programs = {
        nixfmt.enable = true;
        nixf-diagnose.enable = true;
        rustfmt.enable = true;
        toml-sort.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        swift-format.enable = true;

        stylua = {
          enable = true;
          settings = {
            indent_type = "Spaces";
            indent_width = 2;
            quote_style = "ForceDouble";
            call_parentheses = "Always";
            sort_requires.enabled = true;
          };
        };
      };
    }).config.build;
in
formatters.wrapper
