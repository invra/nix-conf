$env.config.show_banner = false;
$env.config.use_kitty_protocol = true;
$env.config.buffer_editor = "nvim"

alias d = cd
alias nv = nvim
alias ncim = nvim
alias gc = git clone

export def greet [name] {
  $"Hello, ($name)!"
}

fastfetch
