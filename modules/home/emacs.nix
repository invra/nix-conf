{
  ...
}:
{
  services.emacs.enable = false;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.evil
      epkgs.dashboard
      epkgs.all-the-icons
    ];
    extraConfig = ''
      	  (require 'dashboard)
          (dashboard-setup-startup-hook)
          (setq dashboard-banner-logo-title "Welcome to Emacs")
          (setq dashboard-center-content t)
          (setq dashboard-vertically-center-content t)
          (setq dashboard-icon-type 'all-the-icons)
          (setq inhibit-splash-screen t)
          (setq inhibit-startup-message t)

          (tool-bar-mode 0)
          (scroll-bar-mode 0)
          (menu-bar-mode 0)

          (setq make-backup-files nil)

          (use-package evil
            :init
            (setq evil-want-keybinding nil)
            (evil-mode 1))
    '';
  };
}
