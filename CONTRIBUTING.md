# Contributing Guide

## Instructions

You will need Nix (2.4 or later) with flakes support to contribute to this project.

Actual data should be generated on CI, so you don't have to commit new data to
the repository. Please commit only a lock file to the repository.

### Add a new release

To add support for a new release version of Emacs, use `add-release.sh` script
contained in this repository:

```sh
./add-release.sh 28.1
```

Commit a new version of `releases.lock` to the repository and create a PR.

### Update one of the development branches

To update the data on one of the development branches, update its corresponding
flake input:

```sh
nix flake lock --update-input emacs-git
```

Commit a new version of `flake.lock` to the repository and create a PR.
