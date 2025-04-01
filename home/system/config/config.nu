$env.config.show_banner = false;
$env.config.use_kitty_protocol = true;
$env.config.buffer_editor = "nvim";
$env.editor = "nvim";

alias d = cd
alias nv = nvim
alias ncim = nvim
alias gc = git clone
alias spf = superfile

export def nixos-rbld [] {
  let currDir = $"(pwd)"
  rm -rf $"($env.HOME)/.gtkrc-2.0"
  cd $"($env.HOME)/.nix"
  sudo nix flake update
  sudo nixos-rebuild switch --flake $".#((open config.toml).user.username)" --impure
  cd $currDir
}

fastfetch
