{
  pkgs,
  lib,
  ...
}:

let
  helpers = {
    cpu_load = pkgs.rustPlatform.buildRustPackage {    
      pname = "cpu_load";
      version = "0.1.0";
      src = ./packages/cpu_load;
      cargoLock.lockFile = ./packages/cpu_load/Cargo.lock;
    };

    network_load = pkgs.rustPlatform.buildRustPackage {
      pname = "network_load";
      version = "0.1.0";
      src = ./packages/network_load;
      cargoLock.lockFile = ./packages/network_load/Cargo.lock;
    };

    memory_load = pkgs.rustPlatform.buildRustPackage {
      pname = "memory_load";
      version = "0.1.0";
      src = ./packages/memory_load;
      cargoLock.lockFile = ./packages/memory_load/Cargo.lock;
    };

    menus = pkgs.rustPlatform.buildRustPackage {
      pname = "menus";
      version = "0.1.0";
      src = ./packages/menus;
      cargoLock.lockFile = ./packages/menus/Cargo.lock;
    };
  };
in
{
  home.packages = lib.optionals pkgs.stdenv.isDarwin [ pkgs.lua ];

  programs.sketchybar.enable = lib.mkIf pkgs.stdenv.isDarwin true;
  programs.sketchybar.configType = "lua";
  programs.sketchybar.config = lib.mkIf pkgs.stdenv.isDarwin {
    source = ./config;
    recursive = true;
  };
  programs.sketchybar.includeSystemPath = lib.mkIf pkgs.stdenv.isDarwin true;

  programs.sketchybar.extraPackages = lib.optionals pkgs.stdenv.isDarwin (with helpers; [
    pkgs.aerospace
    network_load
    memory_load
    cpu_load
    menus
  ]);

  programs.sketchybar.service.enable = lib.mkIf pkgs.stdenv.isDarwin true;
}
