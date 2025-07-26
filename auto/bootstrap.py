#!/usr/bin/env python3
import os
import platform
import subprocess
from pathlib import Path
import sys
import urllib.request

SCRIPT_DIR = Path(__file__).resolve().parent

BOOTSTRAP_DIR = SCRIPT_DIR / ".bootstrap"
RUSTUP_BIN = BOOTSTRAP_DIR / "rustup-init"
RUSTUP_HOME = BOOTSTRAP_DIR / "rustup"
CARGO_HOME = BOOTSTRAP_DIR / "cargo"

arch = platform.machine()
if arch == "x86_64":
    RUSTUP_URL = "https://static.rust-lang.org/rustup/dist/x86_64-apple-darwin/rustup-init"
elif arch == "arm64":
    RUSTUP_URL = "https://static.rust-lang.org/rustup/dist/aarch64-apple-darwin/rustup-init"
else:
    print(f"Unsupported architecture: {arch}", file=sys.stderr)
    sys.exit(1)

def download_rustup():
    """Download the rustup-init binary if not present."""
    BOOTSTRAP_DIR.mkdir(parents=True, exist_ok=True)
    if not RUSTUP_BIN.exists():
        print(f"Downloading rustup-init from {RUSTUP_URL}...")
        with urllib.request.urlopen(RUSTUP_URL) as response:
            RUSTUP_BIN.write_bytes(response.read())
        RUSTUP_BIN.chmod(RUSTUP_BIN.stat().st_mode | 0o111)
    else:
        print("rustup-init already exists, skipping download.")

def run_rustup():
    """Run the rustup-init binary with environment variables."""
    env = os.environ.copy()
    env["RUSTUP_HOME"] = str(RUSTUP_HOME)
    env["CARGO_HOME"] = str(CARGO_HOME)
    env["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"

    print("Running rustup-init...")
    subprocess.run(
        [str(RUSTUP_BIN), "-y", "--no-modify-path", "--profile", "minimal"],
        check=True,
        env=env
    )
    print("Do not follow above tasks. This is meant to be a disposable environment.")

def main():
    download_rustup()
    run_rustup()

if __name__ == "__main__":
    main()
