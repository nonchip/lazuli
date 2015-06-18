#!/bin/zsh

find . -name "*.lua" -and -not -path "*/.root/*" | xargs rm -v
find . -name "*.less.css" | xargs rm -v
for i in $(find . -name "*.less")
  lessc $i --clean-css="--s1" > $i.css
./moonc .
./lapis build "$@"
./lapis migrate "$@"
