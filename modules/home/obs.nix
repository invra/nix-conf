{
  lib,
  pkgs,
  linux,
  ...
}:
lib.optionalAttrs linux {
  programs.obs-studio = {
    enable = true;
    package = (pkgs.obs-studio.override {
      cudaSupport = true;
    });
  };
}
