{
  lib,
  linux,
  config,
  flakeConfig,
  ...
}:
lib.optionalAttrs linux {
  hardware = with flakeConfig; {
    graphics.enable = true;
    amdgpu.opencl.enable = lib.mkForce (builtins.elem "amdgpu" (system.graphics.wanted or [ ]));

    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    } // (lib.optionalAttrs (system.graphics ? nvidia) {
      prime = {
        sync.enable = system.graphics.nvidia.prime.sync.enable or true;
        intelBusId = system.graphics.nvidia.prime.intelBusId or "";
        nvidiaBusId = system.graphics.nvidia.prime.nvidiaBusId or "";
        amdgpuBusId = system.graphics.nvidia.prime.amdgpuBusId or "";
      };
    });

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
