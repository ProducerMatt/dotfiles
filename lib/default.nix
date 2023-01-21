{ lib }:
lib.makeExtensible (self:
with builtins lib; let
  callLibs = file: import file { lib = self; };
in
{
  fixSources = callLibs ./fix-sources.nix;
})
