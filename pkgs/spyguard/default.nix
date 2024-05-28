{ lib, stdenv, fetchFromGitHub, pkgs, ... }:

# TODO

stdenv.mkDerivation rec {
  pname = "sshdo";
  version = "1.0";
  date = "2022-11-08";

  src = fetchFromGitHub ({
    owner = "SpyGuard";
    repo = "SpyGuard";
    rev = version;
    sha256 = "0000000000000000000000000000000000000000000000000000";
  });
  buildInputs = with pkgs; [
    which
    python310
    coreutils
  ];
  meta = with lib; {
    homepage = "https://github.com/SpyGuard/SpyGuard";
  };
}
