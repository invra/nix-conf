# Applying this configuration.
After creating the config. It is important to know what the name of the directory is you made.
The name of *that* folder is what you use in the folowwing commands to build.

## Darwin
On macOS you have a different command to the NixOS people. It is `darwin-rebuild`. le'ts construct the command
```sh
  sudo darwin-rebuild switch --flake .#<CONFIG_NAME>
```
## NixOS
On NixOS you have a different command to the macOS people. It is `nixos-rebuild`. le'ts construct the command
```sh
  sudo nixos-rebuild switch --flake .#<CONFIG_NAME>
```

## Setting up home-manager
After applying the config. Home-manager is a universal system to download and configure for your user.
The command to do this config is.
```
 home-manager switch --flake .#<CONFIG_NAME> 
```
