# Automation Scripting
Theres automations scripts are written with Rust.
You will find all the files required in [`./src`](./src/).

## Bootstrapping Cargo
To bootstrap Cargo with Swift run:

```sh
$  swift ./bootstrap.swift
```

The bootstrap script will:
- Create ./.bootstrap folder
- Install rustup script with `-y --no-modify-path --profile minimal`

What **YOU** will need to do:
- Add ~/.nix/auto/.bootstrap/cargo/bin to `PATH`

That's it.

## Running a task.
To run a task, its just like any other Cargo based project you may find with multiple binaries.
```sh
$  cargo r --bin [target]
```

Substitute `[target]` with the following targets:
- `bootstrap-darwin` - The Nix-darwin installation script
  * Installs Nix-darwin.
  * Installs the Nix-darwin sided config
  * Installs the home-manager sided config
- `test` - Bin to test if your cargo toolchain does work. (This is not required *its's just a sanity check.*)