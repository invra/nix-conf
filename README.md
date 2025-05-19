# InvraNet's NixOS Flake

My main operating system is NixOS, which means this flake will be updated often.
This system is meant to be partially modular to allow for configuration and installation for your user.

> [!important]
> If your a current user of this, since commit [4352d6a8](https://gitlab.com/InvraNet/nix-conf/-/commit/4352d6a803fc61e224faf7d0b92e5bcf7ec0edc0) you're config will **NOT** build until converting to a Nix config. Please follow from **Making configuration of your own**.

## Example
This section shows what the flake will look like.
<br><br>
<details open>
<summary>Spotify + Ghostty + Waybar</summary>
![Demo 1](./.res/demo_1.png)
</details>

<details>
<summary>Development Envrionment</summary>
![Demo 2](./.res/demo_2.png)
</details>

<details>
<summary>Neovim with Mako</summary>
![Demo 3](./.res/demo_3.png)
</details>


## Making a Configuration of your own
This is highly recommended to do, as it is what is needed for your system to be <u>*yours*</u>

### File Structure
The file structure for your configurations are inside of ``./configurations/``.
Already configurations (mine), are found in there you may follow off of that.
The use of a directory with the nix file, is there to tell the build system that this is the name of your flake. So folder ``gary`` will correspond with commands ``sudo nixos-rebuild switch --flake .#gary``, ``darwin-rebuild switch --flake .#gary`` or ``home-manager rebuild switch --flake .#gary``.


### Your configuration is still in TOML?
The current commit you are viewing has completely removed the support for TOML. Please follow this to be caught up to date.

#### Prerequisites
  - Nix Repl
  - Your old TOML.

#### Instructions
Firstly, enter the nix repl using:
```shell
nix repl
```

Then enter this, but editing it to your config file name.
```nix
:p builtins.fromTOML (builtins.readFile ./configFile.toml)
```

The output should be copied to your clipboard, for you to paste into a new file.
This new configuration system is dynamic. Follow the steps from making a configuration, and apply this nix file to that file.
