#!/bin/bash
logger *** TF Remote-Exec Started ***
  echo "MGT :: K8s Config :: Let's get started ..."

    echo "MGT :: K8s Config :: Environment ..."
        sudo cp /etc/kubernetes/admin.conf $HOME/
        sudo chown $(id -u):$(id -g) $HOME/admin.conf
        export KUBECONFIG=$HOME/admin.conf
        echo 'export KUBECONFIG=$HOME/admin.conf' >> $HOME/.bashrc
    echo "MGT :: K8s Config :: Environment ... :: Done ..."

  echo "MGT :: K8s Config :: Done ..."
logger *** TF Remote-Exec Stopped ***
