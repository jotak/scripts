#!/bin/bash

############################################################
# Help                                                     #
############################################################
show_help()
{
   echo "Check if the openshift-install runnable looks OK wrt. pull secrets / registry / image"
   echo
   echo "Syntax: ocp-check-installer [-h]"
   echo "Options:"
   echo "h     Print this help."
   echo
}

# Reset in case getopts has been used previously in the shell.
OPTIND=1

while getopts "h?" opt; do
  case "$opt" in
    h|\?)
      show_help
      exit 0
      ;;
  esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

if [ "$#" != "0" ]; then
	echo "Unexpected arguments: $@"
	show_help
	exit 1
fi

if [ ! -f openshift-install ]; then
	echo "The script must run from an OpenShift directory (ie. with openshift-install)"
	exit 1
fi

echo "Making sure the target image exists..."
image=`./openshift-install version | grep "release image" | sed  's/release image //'`
echo "Image name: $image"
podman rmi $image
podman pull --authfile=../pull-secret.json $image
if [ $? -ne 0 ]; then
		echo ""
		echo "❌ Failure"
		echo "You should check for another version: https://openshift-release.apps.ci.l2s4.p1.openshiftapps.com/"
		exit 1
fi

echo "Making sure secrets are valid..."
/work/scripts/podman-check-auth.sh ../pull-secret.json

if [ $? -ne 0 ]; then
		echo "Please update secrets"
		exit 1
fi
