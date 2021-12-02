import ./nix/builtinLibraries.nix
  (builtins.path {
    path = ./data/libraries;
    filter = path: _type:
      with builtins;
      match ".+\\.txt" (baseNameOf path) != null;
  })
