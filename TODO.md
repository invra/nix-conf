# Todo List

**Priority** is measured by how essential the task is.  
This does **not** mean tasks will be completed in order, as some may be more resource-intensive than others.

---

## Consolidate Everything into a Flake

- [ ] Refactor all flake modules using the **DRY principle**  
  - Example: `hyprland.nix` should house `programs.hyprland` for the display manager login  
  - Also configure `<homeManagerModule>.wayland.windowManager.hyprland` in the same file

---

## Helix Editor Improvements

### Keybindings & Motions

Required to simplify common workflows:

- [x] Create a non-intrusive way to copy to `wl-copy` [^3]  
- [x] Add shortcuts for repetitive or time-consuming tasks  

### Other Enhancements

- [x] Switch to the official Helix binary (currently using `evil-helix`) [^2] 
- [ ] Add (or create) a Discord RPC client to share buffer status  

---

## Enhance Nix Configurations
Add more customisation options & features:

- [x] Add macOS Dock settings
- [ ] Add `ignorePackages` (to skip default packages)  
- [ ] Add `extraPackages` (to allow users to specify workflow-specific packages)  
- [ ] Remove the need to include macOS-specific config in the Linux config (and vice versa)
- [ ] Add proper types for user configuration  
- [ ] Add support to disable modules the user doesn't need  

## Port over to new Nix-darwin configuration
(Re)Move the nix options:
- [x] ``hombrew`` [^1]
- [x] ``system.defaults`` - More to be added later to list.[^4]

[^1]: All homebrew packages were either ported or removed from this repo. - 24-05-2025 7a432fdf93fef3db93c72a42d3e8c6880f67e0c2
[^2]: Evil helix -> plain helix. - 26-05-2025 be5f4ed6d88afc270d636a4cc0a794be0ce22c0d
[^3]: Yank to clipboard is by just hitting `y`. - 10-07-2025 2596bdc4ec9428b8909383349c2c1b33f10ab318
[^4]: All was moved to home-manager, including some new wanted options. - 10-07-2025 2121891900e3a14fe795b707a7f56710be73c4aa
