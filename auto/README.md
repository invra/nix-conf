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


## Running a Task

This project uses Cargo like any other multi-binary Rust workspace.
To run a specific task, use:

```sh
cargo run --bin <target> -- [flags]
```

* `--bin <target>` – specifies the binary to run
* `-- [flags]` – passes arguments directly to your binary

### Targets

#### `bootstrap-darwin`

Installs Nix-darwin and sets up both the Home-Manager and Nix-darwin configurations.

Example with a flake config:

```sh
cargo run --bin bootstrap-darwin -- -f macbook
```

* `-f <config_name>` – specifies which flake configuration to apply

#### `test`

Recommended for newer macOS releases. Prints:

* The OS’s pretty name (e.g., `macOS Catalina`)
* The semantic version (e.g., `10.15`)

This acts as a “dry run” to verify that your system info is detected correctly, helping to ensure nothing breaks due to mis-detection.