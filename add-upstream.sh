#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: addup <repo_url> [<remote>]"
	echo ""
	echo "Add remote for github repository"
	echo "  ex : addup https://github.com/hawkular/hawkular-services origin"
	echo ""
	echo "When not provided, <remote> defaults to 'upstream'"
	echo "  ex : addup https://github.com/hawkular/hawkular-services"
	echo ""
	exit
fi

REMOTE="upstream"
if [[ "$#" -gt 1 ]]; then
  REMOTE="$2"
fi

IFS='/'
PARTS=( $1 )

OWNER="${PARTS[3]}"
REPO="${PARTS[4]}"

git remote add $REMOTE https://github.com/$OWNER/$REPO.git
