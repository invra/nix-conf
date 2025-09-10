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
  libgit2,
  openssl,
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
    libgit2
    openssl

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
