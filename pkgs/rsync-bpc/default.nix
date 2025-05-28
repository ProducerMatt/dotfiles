{
  fetchFromGitHub,
  rsync,
}: let
  version = "ed6c77370ebd6e2bbd986606757146941ada6857";
in
  rsync.overrideAttrs (finalAttrs: prevAttrs: {
    inherit version;
    pname = prevAttrs.pname + "-bpc";
    date = "2023-11-27";

    src = fetchFromGitHub {
      owner = "backuppc";
      repo = "rsync-bpc";
      rev = version;
      fetchSubmodules = false;
      sha256 = "sha256-CXGeSWZF0OOhwo+yndkd0ppYILHELBiZIDhHN7BqVYc=";
    };

    patches = [./fix-gettimeofday-error.patch];
  })
