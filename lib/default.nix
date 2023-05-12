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
  filterAllButDefaultNix = key: value:
    value == "regular" && hasSuffix ".nix" key && key != "default.nix";
  rakeThisProfileFolder = folder:
    let
      toImport = name: value: folder + ("/" + name);
    in
    mapAttrsToList toImport
      (filterAttrs filterAllButDefaultNix
        (readDir folder));
  wantedAttrs = listOfNames: a:
    # return only the Attrs in the list of attrs
    filterAttrs (n: v: any (name: n == name) listOfNames) a;
  recUpdateList = listOfAttrs:
    # take list of attrs and merge them all
    foldl' recursiveUpdate { } listOfAttrs;

  # made for constants.nix
  getAllMachineIPs = machine:
    (optionals (machine ? IPv4)
      (catAttrs "address" machine.IPv4)) ++
    (optionals (machine ? IPv6)
      (catAttrs "address" machine.IPv6));
  getTaggedIPs = wantedTag: list:
    filter (x: any (t: t == wantedTag) x.tags) list;
  netIPv4addrs = machineset: tag: wantedMachines:
    catAttrs "address" (concatMap
      (machine:
        (getTaggedIPs tag machineset.${machine}.IPv4))
      wantedMachines);
})
