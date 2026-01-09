{ config, ... }:
{
  configurations.macbook.module = {
    imports = with config.flake.modules.nixos; [
      base
    ];

    system.stateVersion = "24.11";
  };
}
