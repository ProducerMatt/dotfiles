final: prev: {
  linuxPackages_latest =
    prev.linuxPackages_latest.extend
    (lpfinal: lpprev: {
      evdi = lpprev.evdi.overrideAttrs (efinal: eprev: {
        version = "unstable-2023-02-23";
        src = prev.fetchFromGitHub {
          owner = "listout";
          repo = "evdi";
          rev = "a90ecd5f0f09e976e4b8784fa16b92804138b1bd";
          sha256 = "sha256-nrk5ISlQQ37V+WvLctdvkt0+/qR0F9VIp8Qy1BQwcIg=";
        };
      });
    });
  displaylink = prev.displaylink.override {
    inherit (final.linuxPackages_latest) evdi;
  };
}
