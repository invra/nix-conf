{
  home-manager,
  neovim-nightly-overlay,
  development,
  spicetify-nix,
  unstable,
  ...
}:
{
  imports = [
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.invra = ./home.nix;
        extraSpecialArgs = {
          inherit
            neovim-nightly-overlay
            development
            spicetify-nix
            unstable
            ;
        };
      };
    }
  ];
}
