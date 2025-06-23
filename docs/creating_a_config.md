# Creating a Config.

## Location of Configs
The configs live in [./configurations](../configurations). Now you will see all of my configurations in there.
In short I wanted to use the same config, but be able to change stuff I needed.

## Copying a config and making it yours.
Now to point out, my config is split by the exact computer being used. NixOS people have a `hardware-configuration.nix`
they will need to copy, which will be explaned later. It is important to [know your ISA](task/ISA_check.md).

The foloowing ISA's have a certain naming schema.
- `x86_64` - "`*-x86`" - It will have a spceial name followed by `-x86`.
- `aarch64` - "`*-aarch64`" - It will have a spceial name followed by `-aarch64`.
No other ISA is currently supported - most likley won't for a long while.

To copy and make your own, I would highly sugguest copying one of my virtual machine
config specs, as it has the minimal stuff you need, as the networking stuff in my main pc
config is only there for people who need network bridging, if you dong know what
a network bridge is, don't use my main pc config.

### macOS
```
cp ./configurations/mac_vm ./configurations/<YOUR_CONFIG_NAME>
```
Yes, macOS does break this, because I expect you're on a silicon mac. 

### NixOS (x86)
```
cp ./configurations/vm_x86 ./configurations/<YOUR_CONFIG_NAME>-x86
```

### NixOS (aarch64)
```
cp ./configurations/vm_aarch64 ./configurations/<YOUR_CONFIG_NAME>-aarch64
```

On NixOS you have to copy your `hardware-configuration.nix` to the other one.
So `cd` into the drectory your copied to, and run this command.
```sh
cp /etc/nixos/hardware-configuration.nix ./
```

This will allow for certain settngs to be correct, like your mount and swap layout. With out this your computer will not
turn on again (unless you rollback which is possible in this form of a broken state.)

If you want to have a browse through the config you can. There is no doc/spec for the nix config.
