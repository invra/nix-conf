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
  echo "\e[1;31mError\e[0m: You must specify a flake with the -f flag."
  echo "\e[1;32mUsage:\e[0m $0 -f <flake>"
  exit 1
fi

if ! command -v nix &>/dev/null; then
  echo "\e[1;32m[INFO]\e[0m Nix is not installed. Installing Nix..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
else
  echo "\e[1;32m[INFO]\e[0m Nix is already installed. Skipping installation."
fi


if ! command -v home-manager &>/dev/null; then
  source /etc/zshrc
  if [ "$(sw_vers -productVersion)" = "26.0" ]; then
    echo "\e[1;32m[INFO]\e[0m I am going go edit the LaunchDaemon to go and include the required ENV to not run into crash issues."
    sudo plutil -insert EnvironmentVariables -dictionary /Library/LaunchDaemons/org.nixos.nix-daemon.plist &> /dev/null
    sudo plutil -insert EnvironmentVariables.OBJC_DISABLE_INITIALIZE_FORK_SAFETY -string YES /Library/LaunchDaemons/org.nixos.nix-daemon.plist &> /dev/null
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  fi
  echo "\e[1;32m[INFO]\e[0m The config isn't applied, I will apply it now..."
  zsh -c "sudo nix run nix-darwin --experimental-features 'nix-command flakes' -- switch --flake '.#$flake'"
  source /etc/zshrc
else
  echo "\e[1;32m[INFO]\e[0m The config has already been installed. Use darwin-manager from now on to rebuild."
fi

if ! command -v hx &>/dev/null; then
  echo "\e[1;32m[INFO]\e[0m The home-manager isn't applied, I will apply it now..."
  mkdir "$HOME/Library/Application Support/discord" &> /dev/null
  zsh -c "home-manager switch --flake '.#$flake' -b backup"
else
  echo "\e[1;32m[INFO]\e[0m The config has already been installed. Use darwin-manager from now on to rebuild."
fi
