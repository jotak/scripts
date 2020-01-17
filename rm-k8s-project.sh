#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: rmproject <project-name>"
	echo ""
	exit
fi


PROJECT="$1"

echo "RUN kubectl delete all -l project=$1"
kubectl delete all -l "project=$1"
