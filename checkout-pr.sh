#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: copr <PR URL or ID> [<remote>]"
	echo ""
	echo "Fetch and checkout remote pull-request from github"
	echo "  ex : copr https://github.com/jotak/scripts/pull/2 origin"
	echo "  ex : copr 2 upstream"
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

if [[ "${#PARTS[@]}" == "1" ]]; then
	ID="${PARTS[0]}"
elif [[ "${#PARTS[@]}" -ge "7" ]]; then
	ID="${PARTS[6]}"
else
	echo "Could not read parameter $1: URL or ID expected"
	exit
fi

echo "Pull request ID: $ID"
BRANCHNAME="pr-$ID"

git fetch $REMOTE pull/$ID/head:$BRANCHNAME
git checkout $BRANCHNAME
