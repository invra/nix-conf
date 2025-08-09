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
  ...
}:
mkShell {
  buildInputs = [
    # Rust tools
    cargo
    rustfmt
    rust-analyzer
    rustc

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
