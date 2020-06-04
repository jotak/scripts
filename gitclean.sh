#!/bin/bash

if [[ "$1" = "-h" || "$1" = "help" || "$1" = "--help" ]]; then
	echo "Syntax: gitclean [-a]"
	echo ""
	echo "Fetch all branches one by one, show log and decide wether to keep or delete"
	echo ""
	echo "OPTIONS:"
	echo "  -a		include remote branches"
	echo ""
	exit
fi

BR_OPTS=""

for arg in "$@"
do
	if [[ "$arg" == "-a" ]]; then
		BR_OPTS="-a"
	fi
done

BRANCHES=`git branch $BR_OPTS | sed s/^..// | sed s/-\>.*//`
SPLIT=($BRANCHES)
TOTAL=${#SPLIT[@]}
COUNTER=0

for k in $BRANCHES
do
	COUNTER=$((COUNTER+1))
	DESC=`git log -1 --pretty=format:"%s" $k`
	IN_MASTER=`git log --pretty=oneline --abbrev-commit master | grep "$DESC"`
	echo "BRANCH: $k ($COUNTER/$TOTAL)"
	git log -3 --pretty=format:"%C(blue)%s %C(yellow)(%an) %Cgreen(%cr)%Creset" $k --
	if [[ "$IN_MASTER" == "" ]]; then
           echo -e "\e[1m\e[33mWARN: last commit doesn't seem to exist in master!\e[0m"
	fi
        read -p "Delete? [y/N] " yn
        case $yn in
          [Yy]* ) git branch -D $k;;
          * ) echo "Keeping.";;
        esac
	echo "-----"
done

