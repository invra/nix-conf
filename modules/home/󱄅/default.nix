{
  nixpkgs,
  unstable,
  development,
  ...
}:
let
  utils = import ./utils.nix { inherit (nixpkgs) lib; };
  pkgs = unstable;

  vencord-discord = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };
in
{
  # imports = [
  #   ./system/fastfetch.nix
  #   ./spicetify.nix
  # ];
  imports = utils.getModulesFromDirsRec [./misc ./programs];
  home = {
    stateVersion = "24.11";

    packages = with pkgs; [
      postman
      lazygit
      license-go
      dotnetCorePackages.dotnet_9.sdk
      prismlauncher
      vencord-discord
      remmina
    ];

    file = {
      ".config/ghostty" = {
        source = ./system/config/ghostty;
        recursive = true;
      };
      ".config/starship.toml" = {
        source = ./system/config/starship.toml;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
    };
  };

 }
