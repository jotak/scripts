#!/bin/bash

if [[ "$#" -lt 1 || "$1" = "--help" ]]; then
	echo "Syntax: mirror-istio <version>"
	echo ""
	echo "Mirror Istio images from docker hub to my quay.io"
	echo ""
	exit
fi

v="$1"

for img in proxyv2 pilot; do
	podman pull istio/$img:$v
	podman tag istio/$img:$v quay.io/jotak/$img:$v
	podman push quay.io/jotak/$img:$v
done
