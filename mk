#!/bin/zsh

./moonc .
./lapis build "$@"
./lapis migrate "$@"
