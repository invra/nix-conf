{
  pkgs,
  ...
}:
{
  cpu_load = pkgs.rustPlatform.buildRustPackage {
    pname = "cpu_load";
    version = "0.1.0";
    src = ./cpu_load;
    cargoLock.lockFile = ./cpu_load/Cargo.lock;
  };

  network_load = pkgs.rustPlatform.buildRustPackage {
    pname = "network_load";
    version = "0.1.0";
    src = ./network_load;
    cargoLock.lockFile = ./network_load/Cargo.lock;
  };

  menus = pkgs.rustPlatform.buildRustPackage {
    pname = "menus";
    version = "0.1.0";
    src = ./menus;
    cargoLock.lockFile = ./menus/Cargo.lock;
  };
}
