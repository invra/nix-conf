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
      };
    }).config.build;
in
formatters.wrapper
