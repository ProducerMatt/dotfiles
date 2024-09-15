{
  lib,
  python3Packages,
  git,
}: let
  commonMeta = rec {
    name = "nox";
    version = "0.0.7";
  };
in
  python3Packages.buildPythonApplication rec {
    pname = commonMeta.name;
    inherit (commonMeta) version;
    namePrefix = "";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };

    buildInputs = [python3Packages.pbr git];

    propagatedBuildInputs = with python3Packages; [
      dogpile-cache
      click
      requests
      characteristic
      setuptools
    ];

    meta = {
      homepage = "https://github.com/madjar/nox";
      description = "Tools to make nix nicer to use";
      changelog = "https://github.com/madjar/nox/commit/f732934c24593b8d6bbe2ad0e3700bd836797d80";
      maintainers = [lib.maintainers.ProducerMatt];
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  }
