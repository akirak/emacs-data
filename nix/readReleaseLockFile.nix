file:
with builtins;
let
  document = fromJSON (readFile file);
  branchRegex = "emacs-([[:digit:]]+\\.[[:digit:]])";
  versionFromRef = ref: head (match branchRegex ref);
  fromFlakeEntry = { from, to }:
    {
      name = versionFromRef from.ref;
      value = to;
    };
in
listToAttrs (map fromFlakeEntry document.flakes)
