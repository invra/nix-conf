{
  user,
  pkgs,
  ...
}:
{
  imports = if pkgs.stdenv.isLinux then [ ./linux ] else [ ./darwin ];

  nix = {
    settings = {
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
  };

  # nixpkgs.hostPlatform = pkgs.hostPlatform.system;

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
