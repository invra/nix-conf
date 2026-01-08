{ inputs, ... }:
{
  nixpkgs.allowedUnfreePackages = [
    "bitwig-studio-unwrapped"
  ];
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment = {
        systemPackages =
          with pkgs;
          [
            jack2
            git
            home-manager
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            lsof
            foot
            pciutils
            nautilus
            swww
            firefox
            xwayland-satellite
          ];

        shells = with pkgs; [
          bashInteractive
          nushell
        ];
      };

      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        package = (
          pkgs.obs-studio.override {
            cudaSupport = true;
          }
        );
      };
    };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          sl
          (inputs.dev-nix.packages.${stdenv.hostPlatform.system}.default)
          dbgate
          prismlauncher
          viu
          ffmpeg
          file
          fd
          tree
          unzip
          nil
          nixd
          yt-dlp
          yazi
          wget
          firefox
          killall
        ]
        ++ lib.optionals (!(stdenv.isLinux && stdenv.isAarch64)) [
          insomnia
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          steam
          utm
          pika
          linearmouse
          obs-studio
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          wl-clipboard
          wayvnc
          helvum
          easyeffects
          vlc
          gimp3
          pavucontrol
          # davinci-resolve
          krita
          wayvnc
          libreoffice-qt6-still
          kdePackages.kdeconnect-kde
        ]
        ++ (lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
          # wineWowPackages.waylandFull
          # winetricks
          # yabridge
          # (yabridgectl.override { wine = wineWowPackages.waylandFull; })
          bitwig-studio
        ]);

      programs.firefox = {
        enable = true;

        profiles = {
          main = {
            id = 0;
            isDefault = true;
            settings = {
              "browser.newtab.pinned" = [
                {
                  title = "nixos";
                  url = "https://nixos.org";
                }
              ];
            };
          };
        };
      };

      stylix.targets = {
        firefox.profileNames = [ "main" ];
        btop.enable = false;
      };

      programs = {
        ripgrep.enable = true;

        btop = {
          enable = true;
          settings = {
            theme_background = false;
            color_theme = "TTY";
            vim_keys = true;
            update_ms = 1000;
            truecolor = true;
            temp_scale = "celsius";

            proc_aggregate = true;
          };
        };
      };
    };
}
