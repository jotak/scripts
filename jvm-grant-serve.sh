#!/bin/bash

JVM=`jps -lvm | grep Jps | grep -Eo '/usr/lib/jvm/[^[:space:]]+'`
JAVABIN=$JVM/jre/bin/java

echo "JVM found: $JVM"

HASCAP=`getcap $JAVABIN | grep "cap_net_bind_service+ep" | wc -l`

if [[ "$HASCAP" != "0" ]] ; then
	echo "It seems like $JAVABIN does already have cap_net_bind_service+ep"
else
	read -p "Need to setcap... proceed? [yN] " -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]] ; then
		sudo setcap 'cap_net_bind_service=+ep' "${JVM}/jre/bin/java"
	fi
fi

LIBJLI="${JVM}/jre/lib/amd64/jli/libjli.so"
if [ ! -e $LIBJLI ] ; then
	echo "Warning: libjli.so was not found in ${JVM}/jre/lib/amd64/jli"
	echo "Cannot create symlink in /usr/lin (see also https://techblog.jeppson.org/2017/12/make-java-run-privileged-ports-centos-7/)"
	exit 0
fi

OLDLIBJLI=`readlink /usr/lib/libjli.so`
if [[ "$LIBJLI" == `readlink /usr/lib/libjli.so` ]] ; then
	echo "Current libjli symlink in libjli does already point to ${LIBJLI}, nothing to change."
	exit 1
fi

echo "  Old libjli: $OLDLIBJLI"
echo "  New libjli: $LIBJLI"
read -p "Proceed with symlink update? [yN] " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
	exit 1
fi

if [[ -L "/usr/lib/libjli.so" ]] ; then
	echo "removing symlink"
	sudo rm /usr/lib/libjli.so
fi

sudo ln -s $LIBJLI /usr/lib/
sudo ldconfig
