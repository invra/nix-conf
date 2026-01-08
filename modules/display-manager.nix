{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        config = {
          preferred = {
            default = "gtk";
            "org.freedesktop.impl.portal.ScreenCast" = "wlr";
            "org.freedesktop.impl.portal.Screenshot" = "wlr";
          };
        };
      };
    };
}
