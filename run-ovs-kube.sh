#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: $0 <command>"
	echo ""
	echo "Run a command on each OVS pod"
	echo ""
	exit
fi

ovspods=`kubectl get pods -n ovn-kubernetes -l app=ovs-node --no-headers -o custom-columns=":metadata.name"`

args=""
for arg in "$@"; do
	if [[ "$arg" == *\ * ]]; then
		args="$args \"$arg\""
	else
		args="$args $arg"
	fi
done

for pod in $ovspods; do
	echo $pod
	kubectl exec -n ovn-kubernetes $pod -- $args
done
