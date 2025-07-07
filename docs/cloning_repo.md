# Cloning the Repository with Git

If you're reading this, you might be new to Git or want to make sure you’re doing this step correctly.

## Cloning

I don't know which Git hosting platform you’re using, but the only *officially supported* one for this project is [GitLab](https://gitlab.com).

The reason: I may drop other platforms in the future, so it’s safest to use the remote I primarily maintain and will continue to support.

To clone the repository, run the appropriate command below:

### GitLab

```sh
nix run nixpkgs#git --extra-experimental-features "nix-command flakes" -- clone https://gitlab.com/<username>/<fork-name> ~/.nix
````

### GitHub

```sh
nix run nixpkgs#git --extra-experimental-features "nix-command flakes" -- clone https://github.com/<username>/<fork-name> ~/.nix
```

### Codeberg

```sh
nix run nixpkgs#git --extra-experimental-features "nix-command flakes" -- clone https://codeberg.org/<username>/<fork-name> ~/.nix
```

> [!IMPORTANT]
> It is **imperative** that the repository is cloned into the `~/.nix` directory,
> because the custom toolchains expect the code to be located there.

---

After cloning, proceed back to [the README](./README.md) for the next step.
