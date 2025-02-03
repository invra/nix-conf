# InvraNet's NixOS Flake

My main operating system is NixOS, which means this flake will be updated often.
This system is meant to be partially modular to allow for configuration and installation for your user.

## Configuration
Inside of the root of this directory, you have your `config.toml`, which specifies how
`home/home.nix`, `flake.nix`, etc handle and configure certain pieces of the system.
Most of these settings pertain to your user account, networking, system services,
graphics, and window management.

Your `config.toml` looks like this from the start:

```toml
[user]
username = "invra"
displayName = "InvraNet"
initialPassword = "123456"

[system]
hostname = "NixOS"
timezone = "Australia/Sydney"
locale = "en_AU.UTF-8"
kernelParams = [
    "intel_iommu=on",
    "iommu=pt",
    "vfio-pci.ids=10de:2182,10de:1aeb,10de:1aec,10de:1aed",
]

[system.graphics]
blacklists = ["nouveau", "nvidia"]
wanted = ["amdgpu"]

[[system.graphics.processor]]
type = "AMD"
name = "Radeon RX 6700 XT"
driver = "amdgpu"

[[system.graphics.processor]]
type = "NVIDIA"
name = "GeForce GTX 1660 Ti"
driver = "nvidia"

[system.services]
ssh.enable = true
mongodb.enable = true

[desktop]
[desktop.hyprland]
enable = true
wallpapers = [
    "DP-3, /home/invra/.wallpapers/Catalina Coast.png",
    "DP-2, /home/invra/.wallpapers/Catalina Coast.png",
]

[[desktop.hyprland.monitors]]
name = "DP-2"
resolution = "2560x1440"
refreshRate = 180
position = "0x0"
scale = 1

[[desktop.hyprland.monitors]]
name = "DP-3"
resolution = "1920x1080"
refreshRate = 180
position = "2560x0"
scale = 1

[development]
[development.git]
username = "InvraNet"
email = "identificationsucks@gmail.com"
defaultBranch = "main"
```

Your file needs to specify the correct details. Below is a breakdown of each section and its properties.

---

## `[user]` section
This section contains user-related settings.

- `username`: Specifies the username to be used for home-manager and the user to be created.
- `displayName`: Specifies the display name used in the `description` field for user settings in `config/configuration.nix`.
- `initialPassword`: Only used if the flake is applied during the installation of NixOS or as a built ISO. This sets the user's initial password. **Do not use your actual password** here; instead, change it afterward using `passwd`.

---

## `[system]` section
Configures system-wide settings.

- `hostname`: The system's hostname, used in the network and shell (e.g., `[username]@[hostname]`).
- `timezone`: Specifies the system's timezone. You can find your timezone using `timedatectl list-timezones`.
- `locale`: Sets the system's default locale (e.g., `en_AU.UTF-8`).
- `kernelParams`: A list of kernel parameters applied at boot.

### `[system.graphics]` section
Configures GPU settings.

- `blacklists`: A list of kernel modules to blacklist (e.g., `nouveau`, `nvidia`).
- `wanted`: Specifies the preferred graphics drivers (e.g., `amdgpu`).

#### `[[system.graphics.processor]]` (Multiple entries allowed) **Currently functionless, but will be used in the future, so pleese configure accordingly...**
Configures individual graphics processors.

- `type`: Specifies the GPU vendor (e.g., `AMD`, `NVIDIA`).
- `name`: Specifies the GPU model.
- `driver`: Specifies the graphics driver to use.

### `[system.services]` section
Controls system services.

- `ssh.enable`: Enables SSH access if set to `true`.
- `mongodb.enable`: Enables MongoDB if set to `true`.

---

## `[desktop]` section
Configures desktop environment settings.

### `[desktop.hyprland]` section
Configures Hyprland settings.

- `enable`: Enables Hyprland if set to `true`.
- `wallpapers`: A list of monitor-specific wallpapers in the format `"<monitor_name>, <path_to_wallpaper>"`.

#### `[[desktop.hyprland.monitors]]` (Multiple entries allowed)
Defines monitor configurations.

- `name`: The monitor's identifier (e.g., `DP-2`).
- `resolution`: The monitor's resolution (e.g., `2560x1440`).
- `refreshRate`: The monitor's refresh rate in Hz.
- `position`: The monitor's position (e.g., `2560x0`).
- `scale`: The display scaling factor.

---

## `[development]` section
Configures development tools.

### `[development.git]` section
Configures Git settings.

- `username`: Default Git username for commits.
- `email`: Default Git email for commits.
- `defaultBranch`: Default branch to use when running `git init`.

---

This configuration file provides a modular and flexible way to manage your NixOS system, ensuring user settings, system services, desktop environments, and development tools are consistently applied. Modify `config.toml` as needed to match your preferences.
