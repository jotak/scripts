#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: $0 <dir name>"
	echo ""
	echo "  E.g. $0 ovnk"
	exit
fi

OSDIR_OLD="$1"
OSDIR="$2"

if [[ "$OSDIR" == "" ]]; then
	OSDIR="$1"
fi

echo "*** WITH EXISTING CONFIG ***"
echo "mkdir $OSDIR && cp ./install-config.yaml.keep $OSDIR/install-config.yaml"
echo "sed -i 's/name: jtakvori-.*/name: jtakvori-$OSDIR/' ./$OSDIR/install-config.yaml"
echo "./openshift-install --dir $OSDIR create cluster"
echo ""
echo "******* FROM SCRATCH *******"
echo "./openshift-install --dir $OSDIR_OLD destroy cluster"
echo "rm -rf $OSDIR_OLD"
echo "wl-copy < ../pull-secret.json"
echo "./openshift-install --dir $OSDIR create install-config"
echo "# key: use openshift-dev"
echo "# cluster name: jtakvori-$OSDIR"
echo "# (paste when prompted for secret)"
echo "sed -i 's/OpenShiftSDN/OVNKubernetes/' ./$OSDIR/install-config.yaml"
echo "./openshift-install --dir $OSDIR create cluster"
echo ""
echo "Later:"
echo "oc login https://api.jtakvori-$OSDIR.devcluster.openshift.com:6443 -u kubeadmin"
