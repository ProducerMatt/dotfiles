{ lib, ... }:

with builtins lib; rec {
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
        (x: removeAttrs d [ "date" "version" ])
      ];
}
