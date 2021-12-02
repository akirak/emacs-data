{ lib, stdenv, ripgrep, writeShellScriptBin, symlinkJoin }:
{ sources, logFile }:
with builtins;
let
  existingHashes =
    if pathExists logFile
    then
      lib.pipe (readFile logFile) [
        (split "\n")
        (filter isString)
        (map (name: { inherit name; value = null; }))
        listToAttrs
      ]
    else { };

  generateLibraryListFromSource = import ./generateLibraryList.nix {
    inherit stdenv ripgrep;
  };

  results = lib.pipe sources [
    (filter (source: !hasAttr source.rev existingHashes))
    (map (source: {
      name = source.rev;
      value = generateLibraryListFromSource source;
    }))
    listToAttrs
  ];

  canonical = symlinkJoin {
    name = "library-lists";
    paths = attrValues results;
  };

  newLog = toFile "log.txt"
    (lib.concatMapStrings (hash: hash + "\n") (attrNames results));

in
writeShellScriptBin "generate"
  (
    if results == { }
    then "echo Nothing to be done."
    else
      ''
        set -euo pipefail

        install -v ${canonical}/*.* ./data/libraries

        cat ${newLog} >> ./log.txt
      ''
  )
