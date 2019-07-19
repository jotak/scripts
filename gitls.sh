#!/bin/bash

if [[ "$1" = "-h" || "$1" = "help" || "$1" = "--help" ]]; then
	echo "Syntax: gitls [-a | -g=<str>]"
	echo ""
	echo "List branches with additional info about last commit"
	echo ""
	echo "OPTIONS:"
	echo "  -a		list all branches, including remote ones"
	echo "  -g=<str>	grep"
	echo ""
	exit
fi

BR_OPTS=""
TO_GREP=""

for arg in "$@"
do
	if [[ "$arg" == "-a" ]]; then
		BR_OPTS="-a"
	elif [[ "$arg" == -g=* ]]; then
		TO_GREP=`echo $arg | sed 's/-g=\(.*\)/\1/'`
	else
		gitall_args="$gitall_args $arg"
	fi
done

for k in `git branch $BR_OPTS | sed s/^..// | sed s/-\>.*//`
do
	if [[ "$TO_GREP" == "" ]]; then
		git log -1 --pretty=format:"$k: %C(blue)%s %Cgreen(%cr)%Creset" $k --
	else
		ok=`git log -1 --pretty=format:"$k: %C(blue)%s %Cgreen(%cr)%Creset" $k -- | grep "$TO_GREP"`
		if [[ "$ok" != "" ]]; then
			git log -1 --pretty=format:"$k: %C(blue)%s %Cgreen(%cr)%Creset" $k --
		fi
	fi
done

