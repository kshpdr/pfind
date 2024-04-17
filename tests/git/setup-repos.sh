#!/bin/sh
echo "Setting up Git submodules"

git submodule update --init --recursive
# this should also handle resetting the HEAD of the submodules if needed