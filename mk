#!/bin/zsh

d="$(dirname "$(readlink -f "$0")")"

find . -name "*.lua" -and -not -path "*/.root/*" | xargs rm -v
find . -name "*.less.css" | xargs rm -v

if which lessc >/dev/null 2>&1
  then for i in $(find . -name "*.less")
    do lessc $i --clean-css="--s1" > $i.css
  done
fi

$d/moonc .
$d/lapis build "$@"

test -f "migrations.moon" && $d/lapis migrate "$@"
