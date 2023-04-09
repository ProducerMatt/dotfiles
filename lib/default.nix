{ lib }:
lib.makeExtensible (self:
with builtins; with lib; let
  callLibs = file: import file { lib = self; };
in
rec {
  descendOne = f: mapAttrs (n: v: f v);
  pnameToName = L:
    (mapAttrs' (name: value:
      nameValuePair
        (if name == "pname" then "name" else name)
        value))
      L;
  removeUnwanted = listOfUnwanted: L: (filterAttrsRecursive
    (name: value: all (item: name != item) listOfUnwanted)
    L);
  cleanForFish =
    S: pipe S
      [
        (pnameToName)
        (x: removeAttrs x [ "date" "version" ])
      ];
  filterAllButDefaultNix = key: value: value == "regular" && lib.hasSuffix ".nix" key && key != "default.nix";
  rakeThisProfileFolder = folder:
    let
      toImport = name: value: folder + ("/" + name);
    in
    lib.mapAttrsToList toImport
      (lib.filterAttrs filterAllButDefaultNix
        (builtins.readDir folder));
})
