#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: $0 <auth file>"
	echo ""
	echo "Try each login contained in this auth file. Jq needed."
	echo ""
	exit
fi

FILE="$1"
HOSTS=`cat $FILE | jq -r  '.auths | keys[]'`
ALLGOOD=1



for host in $HOSTS; do
	auth=`cat $FILE | jq -r '.auths["'$host'"].auth'`
	email=`cat $FILE | jq -r '.auths["'$host'"].email'`
	echo "podman login $host"
	podman login $host --authfile $FILE
	if [ $? -ne 0 ]; then
	  ALLGOOD=0
		echo "❌"
	else
		echo "✅"
	fi
done

if [ $ALLGOOD -eq 0 ]; then
	echo ""
	echo "Invalid or expired secrets, there was at least one error."
	exit 1
fi
