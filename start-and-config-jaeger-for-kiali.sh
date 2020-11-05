#!/bin/bash

kubectl get cm kiali -n istio-system -o yaml \
	| awk '/url: \047\047/{c+=1}{if(c==3){sub("url: \047\047","url: http://localhost:16686/jaeger",$0)};print}' \
	| kubectl replace -n istio-system -f - 

kubectl delete pod -n istio-system -l app=kiali

istioctl dashboard jaeger
