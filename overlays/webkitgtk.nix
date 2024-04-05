final: prev: let
  opencv4-noCuda = prev.opencv4.override {
    enableCuda = false;
  };
in {
  gst-plugins-bad = prev.gst_all_1.gst-plugins-bad.override {
    opencv4 = opencv4-noCuda;
  };
  webkitgtk = prev.webkitgtk.override {
    inherit (final) gst-plugins-bad;
    #enableGLES = false;
    #stdenv = prev.stdenv.override {
    #  enableParallelBuilding = false;
    #};
    #stdenv = prev.llvmPackages_15.stdenv;
  };
  gtk4 = prev.gtk4.override {
    inherit (final) gst_all_1;
  };
}
