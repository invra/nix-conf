{ unstable, ... }:
{
  home.packages = with unstable; [ glab ];
  # Left here for future reference
  # home = {
  # packages = [ glab ];
  # file.".config/glab-cli/config.yml" = {
  #   text = ''
  #     git_protocol: ${protocol}
  #     editor: ${editor}
  #     check_update: false
  #     glamour_style: dark
  #   '';
  #   force = false;
  #   mutable = true;
  # };
  # };
}
