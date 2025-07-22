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

  home.packages = with pkgs; [
    vivid
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
      $env.LS_COLORS = (vivid generate rose-pine)

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
