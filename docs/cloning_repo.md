# Cloning repo with Git.
Now for people who are reading this, either don't know what their doing or have realized this need to be done specially.

## Cloning
Now I don't know what Git platform you're reading this from. But the only right one is [Gitlab](https://gitlab.com)

In short the reason is I might at a point down th road drop these other platforms. So its better to be safe
with the remote being the one I primarily use and will never drop.

To clone run this:

Gitlab:
```sh
nix run nixpkgs#git --extra-experimental-features "nix-command flakes" -- clone https://gitlab.com/<username>/<fork-name> ~/.nix
```

Github:
```sh
nix run nixpkgs#git --extra-experimental-features "nix-command flakes" -- clone https://github.com/<username>/<fork-name> ~/.nix
```

> [!important]
> It is imperative we have it cloned to `~/.nix` due to custom toolchains I made expect `~/.nix`.

Go back to [the README](./README.md) for next step.