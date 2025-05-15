$env.PATH = $env.PATH | append [ "/Users/peter/.nix-profile/bin" "/nix/var/nix/profiles/default/bin" "/etc/profiles/per-user/peter/bin" "/run/current-system/sw/bin" "/opt/homebrew/bin" "/opt/homebrew/sbin" "~/.bun/bin" "~/.deno/bin" "~/.spicetify"]
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
$env.config.show_banner = false

# Aliases
alias la = ls -a
alias fuckoff = exit
alias d = cd
alias nv = nvim
alias ncim = nvim
alias vim = nvim
alias vi = nvim
alias gc = git clone
alias spf = superfile

if not ("x" in $env) {
  fastfetch # Flex your OS.
}

$env.x = true

export def dev [] {
  nix develop --command nu
}


mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
