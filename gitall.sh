#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: gitall <command> <arg1> ... <argn>"
	echo ""
	echo "Execute the git command on several components."
	echo "ex : gitall fetch"
	echo "ex : gitall rebase origin/develop"
	echo ""
	echo "Note that gitall will ignore any module directory which contains a file named .gitallignore"
	echo "  So you can do, for instance, 'touch linkit/.gitallignore' from root java dir so that gitall will always ignore project linkit"
	echo ""
	echo "Write 'gitall dummy' to run an empty command (useful to quickly have a look on what is the active branch)"
	echo ""
	exit
else
	modules=( "my" "modules" )
	gitall_args=""
	iArg=0
	for arg in "$@"
	do
		iArg=$iArg+1
		if [[ "$arg" == *\ * ]]; then
			gitall_args="$gitall_args \"$arg\""
		else
			gitall_args="$gitall_args $arg"
		fi
	done
	back=""
	for DIR in "${modules[@]}"
	do
		echo "*****************************************************"
		cd $back$DIR
		if [[ -f .gitallignore ]]; then
			echo ".gitallignore found on $DIR => skip directory"
		else
			branch="`sh -c 'git branch --no-color 2> /dev/null' | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
			echo -e "git$gitall_args on \E[1;34;40m$DIR\E[0m (branch is \E[1;34;40m$branch\E[0m)"
			git$gitall_args
			if [[ "$gitall_args" != " dummy" ]]; then
				if [ $? -ne 0 ]; then
					echo -e '\E[1;31;47mCOMMAND FAILED!\E[0m'
				fi
			fi
		fi
		back="../"
	done
fi

