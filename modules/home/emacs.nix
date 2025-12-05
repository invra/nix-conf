{
  ...
}:
{
  services.emacs.enable = false;

  programs.emacs = {
    enable = true;
  	extraPackages = epkgs: [
  	  epkgs.evil
  	];
  	extraConfig = ''
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      (menu-bar-mode 0)

      (setq inhibit-startup-message t) 
      (setq initial-scratch-message nil)

      (setq make-backup-files nil)

      (use-package evil
        :init
        (setq evil-want-keybinding nil)
        (evil-mode 1))
    '';
  };
}
