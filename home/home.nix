spicePkgs: pkgs: inputs:
{ development, user, pkgs, stable, ... }: {
  imports = [
    (import ./system/programs.nix development pkgs inputs)
    (import ./spicetify.nix spicePkgs pkgs inputs)
    (import ./system/fastfetch.nix development)
    ./system/stylixTargets.nix
    ./system/hyprland.nix
    ./system/plasma.nix
    ./file.nix
  ];

  home = {
    username = user.username;
    homeDirectory = "/home/" + user.username;
    stateVersion = "24.11";
       sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
    };
  };
}
