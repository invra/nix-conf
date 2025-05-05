{
  desktop,
  user,
  pkgs,
  home-manager,
  development,
  unstable,
  stable,
  nixpkgs-stable,
  nixpkgs,
  plasma-manager,
  hyprpanel,
  spicetify-nix,
  nixcord,
  stylix,
  neovim-nightly-overlay,
  zen-browser,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        sharedModules = [
          plasma-manager.homeManagerModules.plasma-manager
          nixcord.homeModules.nixcord
        ];
        users.${user.username} = ./home.nix;
        extraSpecialArgs = {
          inherit
            desktop
            user
            pkgs
            home-manager
            development
            unstable
            stable
            nixpkgs-stable
            nixpkgs
            plasma-manager
            hyprpanel
            spicetify-nix
            nixcord
            stylix
            neovim-nightly-overlay
            zen-browser
            ;
          username = user.username;
        };
      };
    }

  ];
}
