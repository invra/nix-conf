{ pkgs, pkgs-24_11, ... }:
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
