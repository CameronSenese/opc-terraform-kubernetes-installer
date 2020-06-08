#!/bin/bash
#dashboard, monitoring, & metrics..
  #graphing dependencies (grafana, influxdb, heapster)..
  git clone --quiet https://github.com/kubernetes/heapster >>/tmp/noise.out
  cd /home/opc/heapster/deploy/kube-config/influxdb
  kubectl create -f /home/opc/heapster/deploy/kube-config/influxdb/grafana.yaml >>/tmp/noise.out
  kubectl create -f /home/opc/heapster/deploy/kube-config/influxdb/influxdb.yaml >>/tmp/noise.out
  kubectl create -f /home/opc/heapster/deploy/kube-config/influxdb/heapster.yaml >>/tmp/noise.out
  kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml >>/tmp/noise.out
