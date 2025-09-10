{
  lib,
  linux,
  ...
}:
lib.optionalAttrs linux {
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocales = ["en_US.UTF-8"];

  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_AU.UTF-8";
    LC_ADDRESS = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MESSAGES = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
    LC_COLLATE = "en_AU.UTF-8";
  };
}
