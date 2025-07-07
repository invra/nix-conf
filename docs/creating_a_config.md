# Creating a Config.

## Location of Configs
The configs live in [./configurations](../configurations). Now you will see all of my configurations in there.
In short I wanted to use the same config, but be able to change stuff I needed.

## Copying a config and making it yours.
Now to point out, my config is split by the exact computer being used. NixOS people have a `hardware-configuration.nix`
they will need to copy, which will be explaned later. It is important to [know your ISA](./task/ISA_check.md).

> [!TIP]
> If you're using a Mac, you're probably gonna be on the aarch64 ISA.
> While on a non-apple machine you're probably gonna be on an x86_64 (aka x64) ISA.
> There are other ISAs but those aren't supported yet, so if you happen to be on
> one of them (pretty unlikely), you're gonna be fine.

Configurations for NixOS follow these conoventions based on the ISA they're designed for:
- `x86_64` - "`*-x86`" - It will have a spceial name followed by `-x86`.
- `aarch64` - "`*-aarch64`" - It will have a spceial name followed by `-aarch64`.

No other ISA is currently supported - most likley won't for a long while.

Configurations for macOS (nix-darwin) are prefixed with "mac".

To copy and make your own, I would highly sugguest copying one of my virtual machine
config specs, as it uses a minimal suite, as the networking stuff in my main pc
config is only there for people who need network bridging, if you don't know what
a network bridge is, don't use my main pc config.

### macOS
```zsh
cp ~/.nix/configurations/mac_vm ~/.nix/configurations/mac_<YOUR_CONFIG_NAME>
```

### NixOS (x86_64)
```bash
cp ~/.nix/configurations/vm_x86 ~/.nix/configurations/<YOUR_CONFIG_NAME>-x86
```

### NixOS (aarch64)
```bash
cp ~/.nix/configurations/vm_aarch64 ~/.nix/configurations/<YOUR_CONFIG_NAME>-aarch64
```

On NixOS you have to copy your `hardware-configuration.nix` to the other one.
So `cd` into the drectory your copied to, and run this command.
```sh
cp /etc/nixos/hardware-configuration.nix ~/.nix/configurations/<YOUR_CONFIG_NAME_WITH_PREFIX_AND_SUFFIX>
```

This will allow for certain settngs to be correct, like your mount and swap layout. With out this your computer will not
turn on again (unless you rollback which is possible in this form of a broken state.)

If you want to have a browse through the config you can. There is no doc/spec for the nix config yet.
