# NixOS

Follow instructions to get started, it's pretty easy.

## Installation

```
git clone https://gitlab.com/InvraNet/nixos .dotfiles
cd .dotfiles
```

You need to set a few things inside of your ``config.toml``. Here are the basics.

```
[user]
name = "your_username"
display-name = "Your User Name"
intial-password = "do_somethingH3re!?"
sudo = true - false
shell = "nushell"
de = "kde"

[system]
dm = "sddm"
time-zone = "Region/Place"
```

```
sudo nixos-rebuild switch --flake .#YOUR_USERNAME
```

From here, your system will be building, pulling and installing everything.
Please note to delete ``~/.gtkrc-2.0`` before building.
This bug will be fixed with home-manager at some point.
