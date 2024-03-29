#!/bin/bash

if [[ "$#" -lt 2 || "$1" == "--help" || "$2" == "--help" ]]; then
  echo ""
	echo "Syntax: $0 <source file> <c|u|p|a|g|e|d>"
  echo ""
  echo "c: create new file"
  echo "u: update last generated file"
  echo "p: prepare without kube-apply"
  echo "a: kube-apply without any change"
  echo "g: get deployed resource"
  echo "e: edit deployed resource"
  echo "d: delete resource"
  exit 0
fi

needvim=false
prepare=false
create=false
create=false
apply=false
get=false
edit=false
delete=false
source=""

for arg in "$@"
do
	if [[ "$arg" == "c" ]]; then
		create=true
	elif [[ "$arg" == "u" ]]; then
		update=true
	elif [[ "$arg" == "p" ]]; then
		prepare=true
	elif [[ "$arg" == "a" ]]; then
		apply=true
	elif [[ "$arg" == "g" ]]; then
		get=true
	elif [[ "$arg" == "e" ]]; then
		edit=true
	elif [[ "$arg" == "d" ]]; then
		delete=true
	else
		source="$arg"
	fi
done

if [[ "$get" == "true" ]]; then
  kubectl get -f $source
fi

if [[ "$delete" == "true" ]]; then
  kubectl delete -f $source
fi

if [[ "$create" == "false" && "$apply" == "false" && "$prepare" == "false" && "$edit" == "false" ]]; then
  exit 0
fi

if [[ "$create" == "true" ]]; then
  echo '# REMINDER: to cancel deployment, exit vim with an error with :cq' > /tmp/deploy-interactive-source.yaml
  echo '' >> /tmp/deploy-interactive-source.yaml
  cat $source >> /tmp/deploy-interactive-source.yaml
fi

if [[ "$apply" == "false" ]]; then
  vim /tmp/deploy-interactive-source.yaml
  if [[ "$?" != "0" ]]; then
    echo "Deployment canceled"
    exit 1
  fi
fi

if [[ "$prepare" == "false" ]]; then
  kubectl apply -f /tmp/deploy-interactive-source.yaml
fi
