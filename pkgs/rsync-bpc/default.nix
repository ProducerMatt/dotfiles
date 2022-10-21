{ config, lib, pkgs, stdenv, fetchFromGitHub, ... }:

let version = "7215af4f16b729098193d7dde5a8c3c8c4ae80de";
in
stdenv.mkDerivation {
  pname = "rsync-bpc";
  version = version;
  src = fetchFromGitHub ({
    owner = "backuppc";
    repo = "rsync-bpc";
    rev = version;
    fetchSubmodules = false;
    sha256 = "sha256-CXGeSWZF0OOhwo+yndkd0ppYILHELBiZIDhHN7BqVYc=";
  });
  date = "2021-07-24";
}
