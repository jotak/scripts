##!/bin/bash

BIN="/home/jotak/bin"

if [[ "$#" -lt 1 || "$1" = "help" ]]; then
	echo "Syntax: switch-istioctl.sh <filename>"
	echo ""
	ls -1 "$BIN/istioctl-"*  | tr '\n' '\0' | xargs -0 -n 1 basename
	exit
fi

if [[ "$1" = "list" ]]; then
	ls -1 "$BIN/istioctl-"*  | tr '\n' '\0' | xargs -0 -n 1 basename
        exit
fi

rm "$BIN/istioctl"

echo "ln -s $BIN/$1 $BIN/istioctl"
ln -s "$BIN/$1" "$BIN/istioctl"

istioctl version

