{
  pkgs-24_11,
  unstable,
  user,
  ...
}:
{
  home = {
    homeDirectory = "/home/${user.username}";
    packages = with unstable; [
      vlc
      gimp3
      wayvnc
      helvum
      easyeffects
      pavucontrol
      # davinci-resolve
      signal-desktop-bin

      (bitwig-studio.override {
        bitwig-studio-unwrapped = bitwig-studio5-unwrapped.override {
          vulkan-loader = pkgs-24_11.vulkan-loader;
        };
      })
      wineWowPackages.waylandFull
      winetricks
      yabridge
      (yabridgectl.override { wine = wineWowPackages.waylandFull; })
    ];
  };
}
