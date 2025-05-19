{
  user = {
    username = "invra";
    displayName = "Invraaaa [(>.<)]";
    initialPassword = "123456";
  };
  system = {
    greeter = "gdm";
    hardware-configuration = ./mainpc-hw.nix;
    hostname = "NixOS";
    timezone = "Australia/Sydney";
    locale = "en_AU.UTF-8";
    kernelParams = ["intel_iommu=on"];
  };
}
