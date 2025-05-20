{ ... }:
{
  security = {
    doas = {
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
      enable = true;
    };
    polkit.enable = true;
  };
}
