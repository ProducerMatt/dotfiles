{
  # services.udev.extraRules = ''
  #   # PS5 DualSense controller over USB hidraw
  #   KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666", TAG+="uaccess"

  #   # PS5 DualSense controller over bluetooth hidraw
  #   KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0666", TAG+="uaccess"
  # '';

  hardware.steam-hardware.enable = true;
}
