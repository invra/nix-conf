{ config, ... }:
{
  flake = {
    meta.owner = {
      email = "identificationsucks@gmail.com";
      name = "Invra";
      username = "invra";
      matrix = "@invranet:matrix.org";
    };

    modules = {
      nixos.base = {
        users.users.${config.flake.meta.owner.username} = {
          isNormalUser = true;
          initialPassword = "";
          extraGroups = [ "input" ];
        };

        nix.settings.trusted-users = [ config.flake.meta.owner.username ];
      };
    };
  };
}
