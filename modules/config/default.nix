{ unstable, ... }:
{
  imports = if unstable.stdenv.isLinux then [ ./linux ] else [ ./darwin ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-experimental-features = [
        "pipe-operators"
      ];

      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
