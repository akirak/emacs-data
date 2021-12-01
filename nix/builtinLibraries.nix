dir:
with builtins;
let
  pathForVersion = version: dir + "/${version}.txt";

  parseVersionList = string: filter (s: isString s && s != "") (split "\n" string);

  getBuiltinLibraryList = version: parseVersionList (readFile (pathForVersion version));

  /* Like getBuiltinLibraryList, but returns null if the version data does not exist. */
  getBuiltinLibraryListSafe = version:
    if pathExists (pathForVersion version)
    then getBuiltinLibraryList version
    else null;

  /* Eliminate .txt from the file name. */
  excludeSuffix = s: substring 0 (stringLength s - 4) s;

in
# Provide separate entry points for minimizing I/O.
{
  emacsVersions = map excludeSuffix (attrNames (readDir dir));
  inherit getBuiltinLibraryList;
  inherit getBuiltinLibraryListSafe;
}
