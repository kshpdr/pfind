#!/bin/sh
echo "Setting up data for all tests"
cd github
./setup-repos.sh & wait
cd ..
cd synthetic
./generate-synthetic.sh & wait
cd ..
echo "Done setting up data for all tests"