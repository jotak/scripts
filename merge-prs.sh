#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: mpr <coma-separated ids> [<remote>]"
	echo ""
	echo "Merge several github pull-requests"
	echo "  ex : mpr 42,43,44"
	echo ""
	echo "When not provided, <remote> defaults to 'upstream'"
	echo ""
	exit
fi

remote="upstream"
if [[ "$#" -gt 1 ]]; then
  remote="$2"
fi

IFS=','
ids=( $1 )
IFS=' '

branches=""
for id in ${ids[@]}; do
	echo "Pull request ID: $id"
	git fetch $remote pull/$id/head:mpr-$id
	branches="$branches mpr-$id"
done

echo "git merge --squash $branches"
git merge --squash $branches
git commit -m "Squashed commit of: $1"
