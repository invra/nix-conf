''
  @define-color base  #191724;
  @define-color surface #1f1d2e;
  @define-color mantle #1f1d2e;
  @define-color crust #11111b;

  @define-color text #e0def4;
  @define-color subtext0 #a6adc8;
  @define-color subtext1 #bac2de;

  @define-color surface0 rgba(22, 25, 37, 0.9);
  @define-color surface1 #45475a;
  @define-color surface2 #585b70;
  @define-color surface3 #394161;

  @define-color overlay0 #6c7086;
  @define-color overlay1 #7f849c;
  @define-color overlay2 #9ba3c3;

  @define-color blue #89b4fa;
  @define-color lavender #c4a7e7;
  @define-color sapphire #74c7ec;
  @define-color sky #ebbcba;
  @define-color teal #94e2d5;
  @define-color green #9ccfd8;
  @define-color yellow #f9e2af;
  @define-color peach #fab387;
  @define-color maroon #eba0ac;
  @define-color red #eb6f92;
  @define-color mauve #cba6f7;
  @define-color pink #f5c2e7;
  @define-color flamingo #f2cdcd;
  @define-color rosewater #f5e0dc;

  /* =============================== */
  /* Universal Styling */
  * {
    border: none;
    border-radius: 0;
    font-family: "JetBrains Mono Nerd Font";
    font-size: 14px;
    min-height: 0;
  }

  /* =============================== */

  /* =============================== */
  /* Bar Styling */
  #waybar {
    background: @base;
    color: @text;
  }

  /* =============================== */

  /* =============================== */
  /* Main Modules */
  #custom-launcher,
  #workspaces,
  #window,
  #tray,
  #backlight,
  #clock,
  #battery,
  #pulseaudio,
  #network,
  #mpd,
  #cpu,
  #memory,
  #disk,
  #temperature,
  #custom-music,
  #custom-updates,
  #custom-nordvpn,
  #custom-notifications,
  #custom-power,
  #custom-custom,
  #custom-cycle_wall,
  #custom-clipboard,
  #custom-ss,
  #custom-weather {
    background-color: @surface;
    color: @text;
    border-radius: 5px;
    padding: 5px 1rem;
    margin-top: 5px;
    margin-bottom: 5px;
    margin-right: 15px;
  }

  #custom-power {
    margin-right: 0;
  }

  /* =============================== */
  /* Launcher Module */
  #custom-launcher {
    color: #9ccfd8;
    font-size: 20px;
    padding-top: 0px;
    padding-bottom: 0px;
    padding-right: 13px;
    margin-left: 15px;
  }

  /* =============================== */
  /* Workspaces */
  #workspaces {
    padding-left: 8px;
    padding-right: 8px;
  }

  #workspaces * {
    font-size: 0px;
  }

  #workspaces button {
    background-color: @surface3;
    color: @mauve;
    border-radius: 100%;
    min-height: 14px;
    min-width: 14px;
    margin: 5px 8px;
    padding: 0px;
    transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
    box-shadow: rgba(0, 0, 0, 0.288) 2px 2px 5px 2px;
  }

  #workspaces button.active {
    background: radial-gradient(
      circle,
      #eb6f92 0%,
      #c4a7e7 20%,
      #ebbcba 40%,
      #31748f 60%,
      #9ccfd8 80%,
      #f6c177 100%
    );
    background-size: 450% 450%;
    animation: gradient_f 10s ease-in-out infinite;
    transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
  }

  #workspaces button:hover {
    background-color: @mauve;
  }

  @keyframes gradient {
    0% {
      background-position: 0% 50%;
    }

    50% {
      background-position: 100% 30%;
    }

    100% {
      background-position: 0% 50%;
    }
  }

  @keyframes gradient_f {
    0% {
      background-position: 0% 200%;
    }

    50% {
      background-position: 200% 0%;
    }

    100% {
      background-position: 400% 200%;
    }
  }

  @keyframes gradient_f_nh {
    0% {
      background-position: 0% 200%;
    }

    100% {
      background-position: 200% 200%;
    }
  }

  /* =============================== */

  /* =============================== */
  /* System Monitoring Modules */
  #cpu,
  #memory,
  #temperature {
    color: @blue;
  }

  #memory {
    border-radius: 0px;
  }

  #temperature {
    border-radius: 0px;
  }

  #disk {
    color: @peach;
    border-radius: 0px;
  }

  /* =============================== */
  /* Clock Module */
  #clock {
    color: @flamingo;
  }

  /* =============================== */
  /* Network Module */
  #network {
    color: @blue;
  }

  /* =============================== */

  /* =============================== */
  /* PulseAudio Module */
  #pulseaudio {
    color: @mauve;
    border-radius: 0;
  }

  /* =============================== */

  /* =============================== */
  /* Battery Module */
  #battery {
    color: @green;
    border-radius: 0;
  }

  #battery.charging {
    color: @green;
  }

  #battery.warning:not(.charging) {
    color: @maroon;
  }

  #battery.critical:not(.charging) {
    color: @red;
    animation-name: blink;
    animation-duration: 1s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  }

  @keyframes blink {
    to {
      background: @red;
      color: @surface1;
    }
  }

  /* =============================== */
  /* Tray Module */
  #tray {
    color: @mauve;
    padding-right: 1.25rem;
  }
''