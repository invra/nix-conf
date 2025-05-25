{
  unstable,
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
    };

    shellAliases = {
      fuckoff = "exit";
      la = "ls - a";
      nvim = "${unstable.evil-helix}/bin/hx";
      vim = "${unstable.evil-helix}/bin/hx";
      vi = "${unstable.evil-helix}/bin/hx";
      ncim = "${unstable.evil-helix}/bin/hx";
    };

    extraEnv = ''
      $env.config.buffer_editor = "hx";
      $env.editor = "hx";
      $env.PATH = $env.PATH
      | append [
        "~/.nix-profile/bin"
        "/nix/var/nix/profiles/default/bin"
        ($"/etc/profiles/per-user/(whoami)/bin")
        "/run/current-system/sw/bin"
      ]
    '';

    extraConfig = ''
      export def --env gc [
          source: string, # Repository to clone (e.g gitlab:invra/nix-conf or ssh:gitlab:invra/nix-conf)
          target?: string, # Location to clone to.
          --cd(-c) # Wether to cd into new target.
          --only-hm (-H) # Only build output for Home-manager, and switch.
          --only-config (-C) # Only build output for Configuration, and switch.
      ] {
          let parts = ($source | split row ":")
          if ($parts | length) < 2 {
              print $"(ansi red_bold)Error:(ansi reset) ($source) is not how you specify a repo. Use help \(-h\) to check.."

              return
          }

          let is_ssh = $parts.0 == "ssh"
          let provider = if $is_ssh { $parts.1 } else { $parts.0 }
          let repo = if $is_ssh { $parts.2 } else { $parts.1 }

          let url = if $is_ssh {
              match $provider {
                  "github" => $"git@github.com:($repo).git"
                  "gitlab" => $"git@gitlab.com:($repo).git"
                  _ => {
                      print $"Unsupported SSH provider: ($provider)"
                      return
                  }
              }
          } else {
              match $provider {
                  "github" => $"https://github.com/($repo).git"
                  "gitlab" => $"https://gitlab.com/($repo).git"
                  _ => {
                      print $"Unsupported provider: ($provider)"
                      return
                  }
              }
          }

          let target_dir = if ($target != null) {
              $target
          } else {
              $repo | split row "/" | last
          }

          print $"Cloning from ($url) into ($target_dir)"
          git clone $url $target_dir

          if $cd {
              cd $target_dir
          }
      }

      export def nix-rbld [
          --update (-u)                # To update flake before building (off by default)
          --target (-T): string = "default"   # Your configuration flake (e.g. mainpc)
          --flake (-f): string = "~/.nix"    # Location of flake (default $env.HOME/.nix)
      ] {
          mut flakeTarget: string = ""

          $flakeTarget = ($flake | str replace "~" $env.HOME) + "#" + $"($target | str replace '#' \'\')";

          if $update {
              print $"nix flake update --flake ($flake | path expand)"
              nix flake update --flake ($flake | path expand)
          }


          print $"sudo nixos-rebuild switch --flake ($flakeTarget)"
          sudo nixos-rebuild switch --flake $flakeTarget

          print $"home-manager switch --flake ($flakeTarget) -b backup"
          home-manager switch --flake $flakeTarget -b backup
      }

      export def dev [] {
        nix develop --command nu
      }

      if not ("x" in $env) {
        fastfetch
      }

      $env.x = true



      mkdir ($nu.data-dir | path join "vendor/autoload")
      starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
    '';
  };
}
