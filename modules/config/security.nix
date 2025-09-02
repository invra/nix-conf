{
  lib,
  pkgs,
  linux,
  ...
}:
{
  security = {
    doas = lib.mkIf linux {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    sudo.enable = lib.mkIf linux false;
    sudo-rs = lib.mkIf linux {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };
    polkit.enable = lib.mkIf linux true;
    pam.services.sudo_local.touchIdAuth = lib.mkIf (!linux) true;
  };
}
