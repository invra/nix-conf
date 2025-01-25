$env.config.show_banner = false;
$env.config.use_kitty_protocol = true;

alias d = cd

export def greet [name] {
  $"Hello, ($name)!"
}

fastfetch
