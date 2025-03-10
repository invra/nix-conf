$env.config.show_banner = false;
$env.config.use_kitty_protocol = true;
$env.config.buffer_editor = "nvim";
$env.editor = "nvim";

alias d = cd
alias nv = nvim
alias ncim = nvim
alias gc = git clone
alias spf = superfile

export def greet [name] {
  $"Hello, ($name)!"
}

fastfetch
