#!/bin/bash

giturl=`git remote get-url upstream 2> /dev/null`

if [[ "$giturl" = "" ]]; then
  giturl=`git remote get-url origin 2> /dev/null`
fi

if [[ "$giturl" = "" ]]; then
  echo "Git url no found (no upstream, no origin)"
  exit 1
fi

url=""

if [[ $giturl == http* ]]; then
  url=${giturl%.git}
else
  IFS=':'
  parts=( $giturl )
  IFS=' '
  url="https://github.com/${parts[1]%.git}"
fi

echo "Opening $url"
xdg-open $url
