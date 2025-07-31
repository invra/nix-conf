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
  ...
}:
mkShell {
  buildInputs = [
    # Rust tools
    cargo
    rustfmt
    rust-analyzer

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
