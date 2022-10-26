{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "sshdo";
  version = "f15ee8ec33fcdfc2fc637de03806201741e2c78f";
  date = "2021-09-14";

  src = fetchFromGitHub ({
    owner = "raforg";
    repo = "sshdo";
    rev = version;
    sha256 = "0000000000000000000000000000000000000000000000000000";
  });

  doCheck = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=$(out)/bin"
  ];

  meta = {
    homepage = "https://raf.org/sshdo/";
    changelog = "https://github.com/raforg/sshdo/commit/f15ee8ec33fcdfc2fc637de03806201741e2c78f";
    description = "Easily configure which commands an SSH login can call.";
  };
}
