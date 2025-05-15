$env.config.show_banner = false;
$env.config.use_kitty_protocol = true;
$env.config.buffer_editor = "nvim";
$env.editor = "nvim";

# ENV's
$env.XDG_CONFIG_DIRS = $"($env.XDG_CONFIG_DIRS):($env.HOME)/.config"

alias d = cd
alias nv = nvim
alias ncim = nvim
alias gc = git clone

export def nixos-rbld [] {
  let currDir = $"(pwd)"
  rm -rf $"($env.HOME)/.gtkrc-2.0"
  cd $"($env.HOME)/.nix"
  sudo nix flake update
  sudo nixos-rebuild switch --flake $".#((open config.toml).user.username)"
  cd $currDir
}

if not ("x" in $env) {
  fastfetch # Flex your OS.
}

$env.x = true

export def dev [] {
  nix develop --command nu
}

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
