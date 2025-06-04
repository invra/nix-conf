#!/bin/zsh

while getopts "f:" opt; do
  case $opt in
    f)
      flake=$OPTARG
      ;;
    *)
      echo "Usage: $0 -f <flake>"
      exit 1
      ;;
  esac
done

if [ -z "$flake" ]; then
  echo "Error: You must specify a flake with the -f flag."
  echo "Usage: $0 -f <flake>"
  exit 1
fi

if ! command -v nix &>/dev/null; then
  echo "Nix is not installed. Installing Nix..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
  source /etc/zshrc  # Reload the shell configuration
else
  echo "Nix is already installed. Skipping installation."
fi


if ! command -v home-manager &>/dev/null; then
  echo "The config isn't applied, I will apply it now..."
  echo "Root access is required for a nix-darwin rebuild now. Please enter your password below."
  sudo nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake ".#$flake"
else
  echo "The config has already been installed. Use darwin-manager from now on to rebuild."
fi

if ! command -v hx &>/dev/null; then
  echo "The home-manager isn't applied, I will apply it now..."
  home-manager switch --flake ".#$flake" -b backup
else
  echo "The config has already been installed. Use darwin-manager from now on to rebuild."
fi
