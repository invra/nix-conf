{ unstable, ... }:
let
  pkgs = unstable;
in
{
  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      extraRules = [{
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }];
    };
    polkit.enable = true;
  };
}
