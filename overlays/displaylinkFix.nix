final: prev: {
  linuxPackages_latest =
    prev.linuxPackages_latest.extend
      (lpfinal: lpprev: {
        evdi =
          lpprev.evdi.overrideAttrs (efinal: eprev: {
            version = "unstable-2022-02-23";
            src = prev.fetchFromGitHub {
              owner = "DisplayLink";
              repo = "evdi";
              rev = "64559211ec33390dbf4372e1029455ff58e0e739";
              sha256 = "0000000000000000000000000000000000000000000000000000";
            };
          });
      });
  displaylink = prev.displaylink.override {
    inherit (final.linuxPackages_latest) evdi;
  };
}
