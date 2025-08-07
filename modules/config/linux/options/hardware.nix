{
  lib,
  config,
  flakeConfig,
  ...
}:
with flakeConfig;
{
  hardware = {
    graphics.enable = true;
    amdgpu.opencl.enable = lib.mkForce (
      builtins.elem "amdgpu" (system.graphics.wanted or [ ])
    );

    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        sync.enable = system.graphics.nvidia.prime.sync.enable or true;
        intelBusId = system.graphics.nvidia.prime.intelBusId or "";
        nvidiaBusId = system.graphics.nvidia.prime.nvidiaBusId or "";
        amdgpuBusId = system.graphics.nvidia.prime.amdgpuBusId or "";
      };
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
