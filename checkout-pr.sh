#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: copr <url> [<remote>]"
	echo ""
	echo "Fetch and checkout remote pull-request from github"
	echo "  ex : copr https://github.com/jotak/scripts/pull/2 origin"
	echo ""
	echo "When not provided, <remote> defaults to 'upstream'"
	echo "  ex : copr https://github.com/hawkular/hawkular-services/pull/220"
	echo ""
	exit
fi

REMOTE="upstream"
if [[ "$#" -gt 1 ]]; then
  REMOTE="$2"
fi

IFS='#'
URL=( $1 )

IFS='/'
PARTS=( ${URL[0]} )

ID="${PARTS[6]}"
BRANCHNAME="pr-$ID"

git fetch $REMOTE pull/$ID/head:$BRANCHNAME
git checkout $BRANCHNAME
