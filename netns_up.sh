#!/usr/bin/bash
set -x

ip netns add n1
ip link add dev br1 type bridge
ip link set br1 up
ip netns exec n1 ip link add name vethin1 type veth peer name vethout1
ip netns exec n1 ip link set vethout1 netns 1

ip link set dev vethout1 master br1
ip link set vethout1 up
ip netns exec n1 ip link set vethin1 up
