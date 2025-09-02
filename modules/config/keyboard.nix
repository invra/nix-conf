{
  lib,
  linux,
  flakeConfig,
  ...
}:
{
  system.keyboard = lib.mkIf (!linux) (with flakeConfig; {
    enableKeyMapping = true;
    swapLeftCommandAndLeftAlt = system.keyboard.normalise or false;
    swapLeftCtrlAndFn = system.keyboard.normalise or false;
    remapCapsLockToEscape = system.keyboard.remapCapsToEscape or false;
  });

  xserver = lib.mkIf (!linux) {
    xkb = {
      layout = "us,us";
      options = "grp:alt_shift_toggle,eurosign:e,caps:escape";
      variant = ",workman";
    };
  };
}
