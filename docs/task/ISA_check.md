# Checking Your System Architecture (ISA)
To ensure you're using the correct configuration for your machine, it's important to know your **Instruction Set Architecture** (ISA). Most modern systems will be either:

- `x86_64` (Intel or AMD)
- `aarch64` (Apple Silicon or other ARM-based systems)

## How to Check

### On macOS or Linux:

Run the following command in a terminal:

```sh
uname -m
````

This will output something like:

* `x86_64` → You're on an Intel/AMD 64-bit system.
* `arm64` or `aarch64` → You're on an Apple Silicon or ARM system.
