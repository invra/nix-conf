{
  pkgs,
  ...
}:
{
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
    settings = (pkgs.lib.importTOML ./starship-config.toml);
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
}
