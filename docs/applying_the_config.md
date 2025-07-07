# Applying This Configuration

## First-Time Setup

The setup process differs slightly depending on your operating system:

- **macOS (Darwin)** users should use the provided setup script.
- **NixOS** users should follow the manual steps outlined below.

---

### macOS (Darwin)

Run the setup script to initialize and apply the configuration:

```sh
./darwin_setup.zsh
````

This script uses `nh` to apply both the system and user configurations.

---

### NixOS (Manual Setup)

NixOS users should apply the system and user configurations manually.

1. Apply the system configuration:

```sh
sudo nixos-rebuild switch --flake .#<CONFIG_NAME>
```

2. Apply the user (home-manager) configuration:

```sh
home-manager switch --flake .#<CONFIG_NAME>
```

Replace `<CONFIG_NAME>` with the name of your configuration as defined in the flake.

> \[!NOTE]
> These configurations are currently intended for **single-user systems**.
> While multi-user support may be added in the future, it is unlikely and not planned anytime soon.
>
> * System-level configuration is defined in [`modules/config/nixos`](../modules/config/nixos) or [`modules/config/darwin`](../modules/config/darwin)
> * User-level configuration is defined in [`modules/home`](../modules/home)

---

## Example (NixOS)

```sh
# Apply system configuration:
sudo nixos-rebuild switch --flake .#mainpc_x86

# Apply user configuration:
home-manager switch --flake .#mainpc_x86
```
Certainly — here’s a new section added to your documentation that explains the transition from **manual first-time setup** (especially for NixOS) to using **`nh` commands** afterward.

This keeps the style and tone consistent, with no emojis, and maintains clear structure:

Here’s a polished version of your section with clearer formatting, consistent style, and a small grammar fix:

## After the First Rebuild

Once you've applied the configuration manually for the first time, you can switch to using the `nh` commands for all targets: `nixos`, `darwin`, and `home-manager`.

The manual commands like these:

```sh
  sudo nixos-rebuild switch --flake .#<NAME>
  sudo darwin-rebuild switch --flake .#<NAME>
  home-manager switch --flake .#<NAME>
````

can be replaced with the following `nh` commands:

```sh
  nh os switch -H <NAME>
  nh darwin switch -H <NAME>
  nh home switch -c <NAME>
```

> [!NOTE]
> The `nh` commands expect your flakes to be located in `~/.nix`, which is configured via environment variables.
