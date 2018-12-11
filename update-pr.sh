#!/bin/bash

if [[ "$1" = "--help" ]]; then
	echo "Syntax: updpr [<remote>]"
	echo ""
	echo "Update a remote pull-request from github that was previously fetched and pulled"
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

ID=`git rev-parse --abbrev-ref HEAD | cut -d '-' -f2`

case $ID in
    ''|*[!0-9]*) echo "Looks like I'm not on an already fetched PR. Please change branch first." ;;
    *) git pull $REMOTE pull/$ID/head ;;
esac

