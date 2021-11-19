#!/bin/bash

############################################################
# Help                                                     #
############################################################
show_help()
{
   echo "Start OpenShift on AWS. The script must run from an OpenShift directory (ie. with openshift-install)"
   echo
   echo "Syntax: launch-aws [-s|p|d|c|h]"
   echo "Options:"
   echo "s     Skip secrets verification."
   echo "p     Prepare config without starting cluster."
   echo "d     Destroy last created cluster and exit."
   echo "c     Clean (destroy) last created cluster and continue."
   echo "h     Print this help."
   echo
}

# Reset in case getopts has been used previously in the shell.
OPTIND=1
check_secrets=1
prepare=0
destroy=0
exit_after_destroy=0

while getopts "h?spdc" opt; do
  case "$opt" in
    h|\?)
      show_help
      exit 0
      ;;
    s)
			check_secrets=0
      ;;
    p)
			prepare=1
      ;;
    d)
			destroy=1
			exit_after_destroy=1
      ;;
    c)
			destroy=1
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

today=`LC_ALL=en_US.utf8 date +"%b%d" | awk '{print tolower($0)}'`
inc=0

if [ -f .lastdir ]; then
	lastdir=`cat .lastdir`
	if [ -e $lastdir ]; then
		if [ "$destroy" == "1" ]; then
			./openshift-install --dir "$lastdir" destroy cluster
			rm -rf "$lastdir"
		else
			echo "❗❗ Previous directory '$lastdir' still exists. ❗❗ You should make sure the cluster was destroyed by running:"
			echo "./openshift-install --dir $lastdir destroy cluster && rm -rf $lastdir || rm -rf $lastdir"
			sleep 5
		fi
	fi
	IFS='-'
	parts=( $lastdir )
	if [[ ${parts[0]} == $today ]]; then
		inc=$((${parts[1]} + 1))
	fi
fi

if [ "$exit_after_destroy" == "1" ]; then
	exit 0
fi

instdir="$today-$inc"
echo "$instdir" > .lastdir

echo "Using directory: $instdir"

if [ $check_secrets -eq 1 ]; then
	echo "Making sure secrets are valid..."
	/work/scripts/podman-check-auth.sh ../pull-secret.json

	if [ $? -ne 0 ]; then
			echo "Please update secrets"
			exit 1
	fi
else
	echo "Skipping secrets verification"
fi

if [ -f install-config.yaml.keep ]; then
	echo "Existing config file found, using it"
	mkdir "$instdir" && cp ./install-config.yaml.keep "$instdir/install-config.yaml"
	sed -i "s/name: jtakvori-.*/name: jtakvori-$instdir/" "./$instdir/install-config.yaml"
else
	echo "No config file found, need to create one"
	echo "Now going through interactive steps..."
	echo "# key: use openshift-dev"
	echo "# cluster name: jtakvori-$instdir"
	echo "# Pull secret has been copied to clipboard, paste it when asked for it"
	wl-copy < ../pull-secret.json
	./openshift-install --dir "$instdir" create install-config
	sed -i 's/OpenShiftSDN/OVNKubernetes/' "./$instdir/install-config.yaml"
fi

if [ "$prepare" == "1" ]; then
	echo "Generated config:"
	echo ""
	cat "./$instdir/install-config.yaml"
	echo ""
	echo "To start the cluster, run:"
	echo "./openshift-install --dir \"$instdir\" create cluster"
	echo ""
	echo "To cancel, remove directory:"
	echo "rm -rf $instdir"
	echo ""
	exit 0
fi

./openshift-install --dir "$instdir" create cluster

if [ $? -ne 0 ]; then
    echo "Installation failed 😖"
		exit 1
fi

oc login "https://api.jtakvori-$instdir.devcluster.openshift.com:6443" -u kubeadmin
