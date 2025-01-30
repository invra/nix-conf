# InvraNet's NixOS Flake.
My main operating system is NixOS, which means this flake will be updated often.
This system is meant to be partially modular to allow for configuration and installation for your user.

## Configuration
Inside of the root of this directory, you have your ``config.toml``, which specifies for your ``home/home.nix``, ``flake.nix``, & ``config/configuration.nix`` on how to handle, and configure certain pieces of the system, most of which is your user account, and networking.

Your ``config.toml`` looks a like this from the start.
```toml
[system]
hostname = "InvraNet"
timezone = "Australia/Sydney"

[user]
username = "invra"
displayName = "InvraNet"
initialPassword = "123456"

[system]
hostname = "NixOS"
timezone = "Australia/Sydney"

[development]
[development.git]
username = "InvraNet"
email = "identificationsucks@gmail.com"
defaultBranch = "main"
```
Your file needs to specify the right details. Here is a breakdown on what each property does in this configuration.

### ``[user]`` section.
This section is being used for user related settings.
Your available settings are:
  * ``username``: Specifies username to be used for home-manager, and user to create.
  * ``displayName``: Specifies for in use of ``description`` in user settings in ``config/configuration.nix``.
  * ``initialPassword``: Only used if flake is being used apart of the installment of NixOS, or as a built ISO, which will get your password for the user from the start to be set value. Please set this value as something not actually your password, and use ``passwd`` afterwards if this will be a applied technique for you.

### ``[system]`` section.
Configuration to certain things which will apply to whole system.
  * ``hostname``: A name discoverable on your network and in shell like ``[username]@[hostname]``.
  * ``timezone``: Your timezone used to sync clock. If you are wondering what timezone you may be apart of, use your, or closest cities value from running ``timedatectl list-timezones``, for example someone in Blue Mountains, New South Wales, Australia will be, ``Australia/Sydney``.

### ``[development]`` section
Configuration to certain tools for development.

#### ``[development.git]``
Configuration with git.
  * ``email``: Default email to be used for commits.
  * ``username``: Default username to show for commits.
  * ``defaultBranch``: Default branch to use when doing ``git init``.
