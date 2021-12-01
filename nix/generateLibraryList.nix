{ stdenv, ripgrep }:
src:
stdenv.mkDerivation {
  name = "library-list-${src.rev}";
  inherit src;

  preferLocalBuild = true;
  allowSubstitutes = false;

  buildInputs = [ ripgrep ];

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    decl=$(grep -oP "This directory tree holds version \d[.\d]+\d of GNU Emacs" README)
    if [[ "$decl" =~ [1-9][.0-9]+[0-9] ]]
    then
      version=''${BASH_REMATCH[0]}
      echo "The Emacs version seems to be $version"
    else
      echo "Did not find a version from the README." >&2
      exit 1
    fi

    mkdir $out

    cd lisp
    rg --maxdepth 2 --files-with-matches -g '*.el' \
      'This file is part of GNU Emacs.' \
      | grep -o -E '([^/]+)\.el' \
      | sed -e 's/\.el$//' \
      | sort | uniq \
      > $out/$version.txt
  '';
}
