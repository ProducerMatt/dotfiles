# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  fish-abbreviation-tips = {
    pname = "fish-abbreviation-tips";
    version = "8ed76a62bb044ba4ad8e3e6832640178880df485";
    src = fetchFromGitHub {
      owner = "gazorby";
      repo = "fish-abbreviation-tips";
      rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
      fetchSubmodules = false;
      sha256 = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
    };
    date = "2023-01-23";
  };
  fzf = {
    pname = "fzf";
    version = "8d99f0caa30a626369541f80848ffdbf28e96acc";
    src = fetchFromGitHub {
      owner = "PatrickF1";
      repo = "fzf.fish";
      rev = "8d99f0caa30a626369541f80848ffdbf28e96acc";
      fetchSubmodules = false;
      sha256 = "sha256-nTiFD8vWjafYE4HNemyoUr+4SgsqN3lIJlNX6IGk+aQ=";
    };
    date = "2023-09-16";
  };
  jethrokuan-z = {
    pname = "jethrokuan-z";
    version = "85f863f20f24faf675827fb00f3a4e15c7838d76";
    src = fetchFromGitHub {
      owner = "jethrokuan";
      repo = "z";
      rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
      fetchSubmodules = false;
      sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
    };
    date = "2022-04-08";
  };
  nvmfish = {
    pname = "nvmfish";
    version = "c69e5d1017b21bcfca8f42c93c7e89fff6141a8a";
    src = fetchFromGitHub {
      owner = "jorgebucaran";
      repo = "nvm.fish";
      rev = "c69e5d1017b21bcfca8f42c93c7e89fff6141a8a";
      fetchSubmodules = false;
      sha256 = "sha256-LV5NiHfg4JOrcjW7hAasUSukT43UBNXGPi1oZWPbnCA=";
    };
    date = "2023-04-30";
  };
  replayfish = {
    pname = "replayfish";
    version = "bd8e5b89ec78313538e747f0292fcaf631e87bd2";
    src = fetchFromGitHub {
      owner = "jorgebucaran";
      repo = "replay.fish";
      rev = "bd8e5b89ec78313538e747f0292fcaf631e87bd2";
      fetchSubmodules = false;
      sha256 = "sha256-bM6+oAd/HXaVgpJMut8bwqO54Le33hwO9qet9paK1kY=";
    };
    date = "2022-06-19";
  };
  rsync-bpc = {
    pname = "rsync-bpc";
    version = "7215af4f16b729098193d7dde5a8c3c8c4ae80de";
    src = fetchFromGitHub {
      owner = "backuppc";
      repo = "rsync-bpc";
      rev = "7215af4f16b729098193d7dde5a8c3c8c4ae80de";
      fetchSubmodules = false;
      sha256 = "sha256-CXGeSWZF0OOhwo+yndkd0ppYILHELBiZIDhHN7BqVYc=";
    };
    date = "2021-07-24";
  };
}
