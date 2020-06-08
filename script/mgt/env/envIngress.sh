#!/bin/bash
#ingress..
  #traefik..
  kubectl create -f /tmp/mgt/env/envIngress/traefik-rbac.yaml >>/tmp/noise.out
  kubectl create -f /tmp/mgt/env/envIngress/traefik-dst.yaml >>/tmp/noise.out
  kubectl create -f /tmp/mgt/env/envIngress/traefik-ing.yaml >>/tmp/noise.out
  #sample services..
  kubectl create -f /tmp/mgt/env/envIngress/cheese-dpl.yaml >>/tmp/noise.out
  kubectl create -f /tmp/mgt/env/envIngress/cheese-svc.yaml >>/tmp/noise.out
  kubectl create -f /tmp/mgt/env/envIngress/cheese-ing.yaml >>/tmp/noise.out