{ lib, config, inputs, ... }:
{
  options.configurations = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.flake = let
    outputs = lib.foldl' lib.recursiveUpdate {} (
      lib.mapAttrsToList (name: cfg: 
        let
          isLinux = (lib.hasSuffix "x86" name) || (lib.hasSuffix "aarch64" name);
          isDarwin = lib.hasPrefix "mac" name;
        in {
          nixosConfigurations = lib.optionalAttrs isLinux {
            ${name} = lib.nixosSystem {
              modules = [ cfg.module ];
            };
          };

          darwinConfigurations = lib.optionalAttrs isDarwin {
            ${name} = inputs.nix-darwin.lib.darwinSystem {
              modules = [ cfg.module ];
            };
          };
        }
      ) config.configurations
    );
  in
    lib.mkMerge [
      outputs
      {
        checks = outputs.nixosConfigurations or {}
          |> lib.mapAttrsToList (name: nixos: {
            ${nixos.config.nixpkgs.hostPlatform.system} = {
              "configurations/nixos/${name}" = nixos.config.system.build.toplevel;
            };
          })
          |> lib.mkMerge;
      }
    ];
}