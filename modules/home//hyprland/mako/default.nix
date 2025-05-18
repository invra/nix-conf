{ ... }:
{
  stylix.targets.mako.enable = false;

  services.mako = {
    enable = true;

    settings = {
      border-radius = 10;
      border-size = 3;
      default-timeout = 5000;
      width = 350;
      height = 250;
      icons = 1;
      text-color = "#e0def4";
      max-icon-size = 64;
      margin = "5,5,0,0";
      border-color = "#ebbcba";
      background-color = "#191724";
      anchor = "top-right";

      "category=spotify" = {
        default-timeout = 1000;
        group-by = "category";
      };
    };
  };
}
