{ config, ... }: {
  flake.modules = {
    nixos.base = nixosArgs@{ pkgs, ... }: {
      users.defaultUserShell = pkgs.nushell;
      users.users.${config.flake.meta.owner.username}.shell =
        nixosArgs.config.home-manager.users.${config.flake.meta.owner.username}.programs.nushell.package;
    };
  };

  flake.modules.homeManager.base = { pkgs, ... }: {
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
        l = "ls -l";
        la = "ls -al";
        ":q" = "exit";
        fuckoff = "exit";
        edit = "taskset -c 0-7 hx";
      };

      extraConfig = ''
        #!/bin/nu
        $env.LS_COLORS = (${pkgs.vivid}/bin/vivid generate rose-pine);
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
    };

    stylix.targets.starship.enable = false;
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        character = {
          error_symbol = "[ 󱞪](bold red)";
          success_symbol = "[ 󱞪](bold green)";
          vimcmd_replace_one_symbol = "[<](bold purple)";
          vimcmd_replace_symbol = "[<](bold purple)";
          vimcmd_symbol = "[<](bold green)";
          vimcmd_visual_symbol = "[<](bold yellow)";
        };
        continuation_prompt = "[.](bright-black) ";
        format = "$username$directory$git_branch$git_status$bun$deno$rust$golang$haskell$haxe$zig$c$cpp$cmake$swift$dotnet$nix_shell$time\n$character\n";

        bun.symbol = "bun "; 
        c.symbol = "C "; 
        cmake.symbol = "cmake "; 
        cpp.symbol = "C++ "; 
        deno.symbol = "deno "; 
        directory.read_only = " ro"; 
        dotnet = {
          format = "via [$symbol($version )(target $tfm )]($style)";
          symbol = ".NET ";
        };
        git_branch = {
          symbol = "git ";
          truncation_symbol = "...";
        };
        git_commit.tag_symbol = " tag "; 
        git_status = {
          ahead = ">";
          behind = "<";
          deleted = "x";
          diverged = "<>";
          renamed = "r";
        };
        haskell.symbol = "haskell "; 
        haxe.symbol = "haxe "; 
        nix_shell.symbol = "nix "; 
        package.symbol = "pkg "; 
        rust.symbol = "rust "; 
        swift.symbol = "swift "; 
        zig.symbol = "zig "; 
      };
    };

    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };

    home.file.".hushlogin".text = "";
  };
}

