#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: autosync <directory>"
	echo ""
	echo "Autocommit + rebase + push any git directory"
	echo "  ex : autosync ~/zettlr"
	echo ""
	exit
fi

cd "$1"
git add -A && git commit -m "autocommit"
git fetch && git rebase origin/master && git push origin HEAD:master
