{
  configTOML,
  pkgs,
  extraOverlays,
  allowUnfreePredicate,
  linux,
  ...
}:
let
  inherit (configTOML) user;
in
{
  imports = if linux then [ ./linux ] else [ ./darwin ];

  nixpkgs = {
    config.allowUnfreePredicate = allowUnfreePredicate;
    overlays = extraOverlays;
  };

  nix.settings = {
    cores = 8;
    max-jobs = 1;

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

  users.users = {
    ${user.username} = {
      name = user.username;
      description = user.displayName;
      shell = pkgs.nushell;
    };
  };

  environment.systemPackages = with pkgs; [
    jack2
    git
    helix
    home-manager
    uutils-diffutils
    uutils-findutils
    uutils-coreutils-noprefix
  ];
}
