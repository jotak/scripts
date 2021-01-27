#!/bin/sh

if [[ "$#" -ne 2 || "$1" = "--help" ]]; then
	echo "Syntax: $0 DOMAIN IMAGE"
	echo ""
	echo "Tag and push a given image to Minikube's registry"
	echo "  E.g. : $0 quay.io jotak/connect-debezium"
	echo ""
	exit
fi

DOMAIN="$1"
IMAGE="$2"
IP=`minikube ip`

set -x

podman tag $DOMAIN/$IMAGE $IP:5000/$IMAGE
podman tag $DOMAIN/$IMAGE localhost:5000/$IMAGE
podman push --tls-verify=false $IP:5000/$IMAGE
