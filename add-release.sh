#!/usr/bin/env bash
version="$1"
nix registry pin --registry ./releases.lock github:emacs-mirror/emacs/emacs-$version
