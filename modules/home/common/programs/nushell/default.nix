{
  pkgs,
  ...
}:
{
  imports = [
    ./starship
    ./carpace
    ./zoxide
  ];

  programs.nushell = {
    enable = true;

    settings = {
      show_banner = false;
      use_kitty_protocol = true;
      buffer_editor = "hx";

      completions.external = {
        enable = true;
        max_results = 10000;
      };
    };

    shellAliases = {
      fuckoff = "exit";
      ":q" = "exit";
      l = "ls -l";
      la = "ls-al";
    };

    extraEnv = ''
      $env.EDITOR = "${pkgs.helix}/bin/hx";
      $env.VISUAL = "${pkgs.helix}/bin/hx";
      $env.NH_FLAKE = $"($env.HOME)/.nix";
      $env.NH_OS_FLAKE = $"($env.HOME)/.nix";
      $env.NH_DARWIN_FLAKE = $"($env.HOME)/.nix";
      $env.NH_HOME_FLAKE = $"($env.HOME)/.nix";
      $env.PATH = $env.PATH
      | append [
        "~/.nix-profile/bin"
        "/nix/var/nix/profiles/default/bin"
        ($"/etc/profiles/per-user/(whoami)/bin")
        "/run/current-system/sw/bin"
      ]
    '';

    extraConfig = ''
      #!/bin/nu
      $env.LS_COLORS = (${pkgs.vivid}/bin/vivid generate rose-pine)

      if not ("NU_EXISTING_INSTANCE" in $env) {
        ${pkgs.fastfetch}/bin/fastfetch
      }

      $env.NU_EXISTING_INSTANCE = true

      mkdir ($nu.data-dir | path join "vendor/autoload")
      ${pkgs.starship}/bin/starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
    '';
  };
}
