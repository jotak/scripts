#!/bin/bash

if [[ "$1" = "" || "$1" = "-h" || "$1" = "help" || "$1" = "--help" ]]; then
	echo "Syntax: $0 <file> <prefix>"
	echo ""
	echo "Fix imports in file"
	echo ""
	exit
fi

awk -i inplace '
{
  if ($0 == "import (") {
    in_imports = 1
    print $0
  }
  else if (in_imports == 1) {
    if ($0 == ")") {
      in_imports = 0
      print $0
    }
    else if ($0 != "") {
      print $0
    }
  }
  else {
    print $0
  }
}
' $1

goimports -w -local $2 $1

