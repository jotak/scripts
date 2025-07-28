#!/usr/bin/bash
set -x

ip netns delete n1
ip link del dev br1
ip link del vethin1
ip link del vethout1
