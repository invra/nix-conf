{ ... }:
{
  programs.starship = {
    enable = true;
    settings =  {
      character = {
        error_symbol = "[ 󱞪](bold red)";
        success_symbol = "[ 󱞪](bold green)";
      };
      directory = {
        format = "[ $path ]($style)";
        style = "fg:#c4a7e7 bg:#413951";
        substitutions = {
          Downloads = " ";
          Documents = "󰈙 ";
          Music = " ";
          Pictures = " ";
          Movies = " ";
          Videos = " ";
          Dev = " ";
          Developer = " ";

          dotfiles = " ";
          nix = "󱄅 ";
          ".nix" = "󱄅 ";
        };
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      format = ''
        [](fg:#4a3e47)[ 󱄅  ](bg:#4a3e47 fg:#ebbcba)$username[](bg:#413951 fg:#4a3e47)$directory[](fg:#413951 bg:#463a36)$git_branch$git_status[](fg:#463a36 bg:#26233a)$nodejs$rust$golang$php[](fg:#26233a bg:#2a273f)$time[](fg:#2a273f)
        $character'';
      git_branch = {
        format = "[[ $symbol $branch ](fg:#f6c177 bg:#463a36)]($style)";
        symbol = "";
      };
      git_status = {
        format = "[[($all_status$ahead_behind )](fg:#f6c177 bg:#463a36)]($style)";
        style = "bg:#394260";
      };
      golang = {
        format = "[[ $symbol ($version) ](fg:#908caa bg:#26233a)]($style)";
        style = "bg:#26233a";
        symbol = "";
      };
      nodejs = {
        format = "[[ $symbol ($version) ](fg:#908caa bg:#26233a)]($style)";
        style = "bg:#583e47";
        symbol = "";
      };
      php = {
        format = "[[ $symbol ($version) ](fg:#908caa bg:#26233a)]($style)";
        style = "bg:#26233a";
        symbol = "";
      };
      rust = {
        format = "[[ $symbol ($version) ](fg:#908caa bg:#26233a)]($style)";
        style = "bg:#26233a";
        symbol = "";
      };
      time = {
        disabled = false;
        format = "[[   $time ](fg:#908caa bg:#2a273f)]($style)";
        style = "bg:#584951";
        time_format = "%R";
      };
      username = {
        disabled = false;
        format = "[$user ]($style)";
        show_always = true;
        style_root = "red bold";
        style_user = "bg:#4a3e47 fg:#ebbcba bold";
      };
    };
  };
}
