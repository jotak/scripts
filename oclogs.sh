#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: oclogs <application> [-n <project>] <forwarded args>"
	echo ""
	echo "Show OpenShift pod(s) logs using app label"
	echo "  ex : oclogs kiali --follow"
	echo "  ex : oclogs reviews -n bookinfo -c reviews"
	echo ""
	echo "The script runs something like:"
	echo "  oc logs \`oc get pods -l 'app=<application>' | grep Running | awk '{print \$1}'\`"
	echo ""
	exit
fi

APP="$1"
FWD_ARGS=""
FWD_FROM=1

if [[ "$#" -gt 2 && "$2" = "-n" ]]; then
	oc project $3
  FWD_FROM=3
fi

for var in "$@"; do
	FWD_FROM=$FWD_FROM-1
	if [[ $FWD_FROM -lt 0 ]]; then
		FWD_ARGS="$FWD_ARGS $var"
	fi
done

COL='\033[0;36m'
NC='\033[0m'

PODS=`oc get pods -l 'app='$APP | grep Running | awk '{print $1}'`
for pod in $PODS; do
	echo -e "${COL}oc logs $pod$FWD_ARGS ${NC}"
	oc logs $pod$FWD_ARGS
done
