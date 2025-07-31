{ pkgs, nixpkgs-24_11, ... }:
let
  pkgs-24_11 = import nixpkgs-24_11 { inherit (pkgs) system; };
in
{
  home.packages = with pkgs; [
    yabridge
    (yabridgectl.override { wine = wineWowPackages.waylandFull; })
    (bitwig-studio.override {
      bitwig-studio-unwrapped = bitwig-studio5-unwrapped.override {
        vulkan-loader = with pkgs-24_11; vulkan-loader;
      };
    })
  ];
}
