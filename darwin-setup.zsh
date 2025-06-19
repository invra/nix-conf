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

if [ "$DISRUPT_SOFT_LOCK_AND_OVERRIDE_MACOS_0x1A" != "1" ]; then
  if [ "$(sw_vers -productVersion)" = "26.0" ]; then
    echo "\e[31mYour macOS version is currently not supported due to Nix daemon crashes.\e[0m"
    echo "\e[34mInfo:\e[0m Please downgrade to Sequoia, and install Nix, then upgrade."
    echo "\e[33mhttps://github.com/NixOS/nix/issues/13342 for issue tracking.\e[0m"
    exit 1
  fi
fi



if ! command -v nix &>/dev/null; then
  echo "Nix is not installed. Installing Nix..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
  source /etc/zshrc
else
  echo "Nix is already installed. Skipping installation."
fi


if ! command -v home-manager &>/dev/null; then
  if [ "$DISRUPT_SOFT_LOCK_AND_OVERRIDE_MACOS_0x1A" = "1" ]; then
    if [ "$(sw_vers -productVersion)" = "26.0" ]; then
      echo "I am going go edit the LaunchDaemon to go and include the required ENV to not run into crash issues."
      sudo plutil -insert EnvironmentVariables -dictionary /Library/LaunchDaemons/org.nixos.nix-daemon.plist
      sudo plutil -insert EnvironmentVariables.OBJC_DISABLE_INITIALIZE_FORK_SAFETY -string YES /Library/LaunchDaemons/org.nixos.nix-daemon.plist
      sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
      sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    fi
  fi
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
