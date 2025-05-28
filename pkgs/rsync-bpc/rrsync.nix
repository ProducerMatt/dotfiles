# WARN: not tested recently
{
  rrsync,
  rsync-bpc,
  python3,
}:
rrsync.overrideAttrs (finalAttrs: prevAttrs: {
  pname = "rrsync";
  inherit (rsync-bpc) version src;

  buildInputs = [
    rsync-bpc
    (python3.withPackages (pythonPackages: with pythonPackages; [braceexpand]))
  ];
  # Skip configure and build phases.
  # We just want something from the support directory
  dontConfigure = true;
  dontBuild = true;

  patches = rsync-bpc.patches ++ [./bpc.patch];

  postPatch = ''
    substituteInPlace support/rrsync --replace /usr/bin/rsync ${rsync-bpc}/bin/rsync
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp support/rrsync $out/bin
    chmod a+x $out/bin/rrsync
  '';

  meta =
    rsync-bpc.meta
    // {
      description = "A helper to run rsync-only environments from ssh-logins";
    };
})
