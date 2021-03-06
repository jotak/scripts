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
	# Skip cloud.openshift.com, for some reason it seems always invalid but is unused anyway
	if [ $host != "cloud.openshift.com" ]; then
		echo "podman login $host"
		podman login $host --authfile $FILE < /dev/null
		if [ $? -ne 0 ]; then
			ALLGOOD=0
			echo "❌"
		else
			echo "✅"
		fi
	fi
done

if [ $ALLGOOD -eq 0 ]; then
	echo ""
	echo "❌ Invalid or expired secrets, there was at least one error."
	exit 1
fi

echo ""
echo "✅ Everything looks good."
