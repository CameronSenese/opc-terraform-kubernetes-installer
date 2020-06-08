#!/bin/bash
#service mesh..
  #istio..
  chmod +x /tmp/mgt/env/envSvcMesh/getlatestistio.sh >>/tmp/noise.out
  /tmp/mgt/env/envSvcMesh/getlatestistio.sh >>/tmp/noise.out
  kubectl apply -f istio-0.4.0/install/kubernetes/istio.yaml >>/tmp/noise.out
  kubectl apply -f istio-0.4.0/install/kubernetes/addons/prometheus.yaml >>/tmp/noise.out
  kubectl apply -f istio-0.4.0/install/kubernetes/addons/grafana.yaml >>/tmp/noise.out
  kubectl apply -f istio-0.4.0/install/kubernetes/addons/zipkin.yaml >>/tmp/noise.out
  export PATH="$PATH:/home/opc/istio-0.4.0/bin"
  echo 'export PATH="$PATH:/home/opc/istio-0.4.0/bin"' >> $HOME/.bashrc
  #bookstore..
  kubectl apply -f <(istioctl kube-inject -f /home/opc/istio-0.4.0/samples/bookinfo/kube/bookinfo.yaml) >>/tmp/noise.out
  #tools.. (tba)..
  #kubectl apply -f <(istioctl kube-inject -f istio-0.4.0/samples/sleep/sleep.yaml)
  #kubectl apply -f <(istioctl kube-inject -f istio-0.4.0/samples/httpbin/httpbin.yaml)