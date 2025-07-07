# Applying this configuration.


## First time

When applying the configurations for the first time, use the `nixos_setup.sh` and
`darwin_setup.zsh` to configure your systems and apply the configurations for the first time
After that you can use the commands in the following section

## Rebuilding after the first time

After creating the config. It is important to know what the name of the directory is you made.
The name of *that* directory is what you use in the following commands to build.

>[!note]
> As it stands now the configurations are geared towards single user systems.
> In future this may change though it's severly unlikely and even if it does
> it won't be soon.
>
> As a rule of thumb, the configuration done at the super user level is done
> using [modules/config/nixos](../modules/config/nixos) or [modules/config/darwin](../modules/config/darwin) modules (depending on the system)
> while user level configuration is done using [modules/home](../modules/home) modules

### Darwin
```sh
  nh darwin switch -uH <CONFIG_NAME>
```

### NixOS
```sh
  nh os switch -uH <CONFIG_NAME>
```

### Setting up home-manager
After applying the config. [home-manager](https://www.github.com/nix-community/home-manager) is a universal system to download and configure for your user.
The command to do this config is.
```sh
 nh home switch -us <CONFIG_NAME> 
```

### Example
```sh
# On NixOS to build the mainpc_x86 configuration you'll run
nh os switch -uH mainpc_x86

# NixOS will build the config and switch to it, and though it's really rare
# you may need to reboot

#Once you're done to run home-manager you may run
nh home switch -us mainpc_x86
```
