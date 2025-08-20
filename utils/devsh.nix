{
  mkShell,
  cargo,
  rustfmt,
  rust-analyzer,
  nixd,
  nil,
  zig,
  zls,
  swift,
  swiftformat,
  rustc,
  clippy,
  pkg-config,
  ...
}:
mkShell {
  buildInputs = [
    # Rust tools
    cargo
    rustfmt
    rust-analyzer
    rustc
    clippy
    pkg-config

    # Nix tools
    nixd
    nil

    # Zig tools
    zig
    zls

    # Swift
    swift
    swiftformat
  ];
}
