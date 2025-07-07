# Invra's Nix Flake

This is a flake for NixOS and also supports Nix-darwin! It’s designed to be modular for others to use. This *is* more for *advanced users*, so if you’re up for the task, this flake might be for you.

## Use

This flake is tailored for my use, but it may align with yours. Here's a list below:

* Keyboard-centric
* Mostly terminal-centric
* Minimalism where wanted, but complexity where needed (e.g., audio patch software, advanced networking support)
* Declarative, convenient, reproducible setup (3–10 commands and you're good to go)
* Networking (Docker, NetworkManager, advanced interface configs for bridging)

## Support

* `aarch64-darwin`
* `x86_64-linux`
* `aarch64-linux`

## Example

This section shows example configurations using this flake.

<details open>
<summary>NixOS – Spotify + WezTerm + Hyprland</summary>
<img src="./.res/demo_1.png" alt="Demo 1">
</details>

<details>
<summary>NixOS – Vesktop + Browsing + PiP</summary>
<img src="./.res/demo_2.png" alt="Demo 2">
</details>

<details>
<summary>NixOS – Neovim with Mako</summary>
<img src="./.res/demo_3.png" alt="Demo 3">
</details>

<details>
<summary>Nix-darwin – Neovim + Spotify</summary>
<img src="./.res/demo_4.png" alt="Demo 4">
</details>

## Making a Configuration of Your Own

It’s highly recommended to create your own configuration — this is what makes the system truly ***yours***.

### File Structure

Your configurations should live inside the `./configurations/` directory.
You’ll find my personal configurations there as examples to follow.

Each configuration resides in a directory named after the profile, which informs the flake system of its identifier.
For example, a folder named `gary` corresponds to the following commands:

```sh
sudo nixos-rebuild switch --flake .#gary
nh os switch -H gary
sudo darwin-rebuild switch --flake .#gary
nh darwin switch -H gary
home-manager rebuild switch --flake .#gary
nh home switch -c gary
```
