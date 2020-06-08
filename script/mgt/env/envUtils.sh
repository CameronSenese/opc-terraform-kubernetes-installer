#!/bin/bash
#tools..
  #git..
  yum install git -y >>/tmp/noise.out
  #curl..
  yum install -y wget curl >>/tmp/noise.out
  #wget..
  yum install -y wget >>/tmp/noise.out
  #go..
  wget -q https://dl.google.com/go/go1.9.2.linux-amd64.tar.gz >>/tmp/noise.out
	tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz >>/tmp/noise.out
	export PATH=$PATH:/usr/local/go/bin >>/tmp/noise.out
	echo 'export PATH="$PATH:/usr/local/go/bin"' >> $HOME/.bashrc >>/tmp/noise.out
  #gobench..
	GOPATH=/tmp/ go get github.com/valyala/fasthttp
	GOPATH=/tmp/ go get github.com/cmpxchg16/gobench
	export PATH=$PATH:/tmp/bin
	echo 'export PATH="$PATH:/tmp/bin"' >> $HOME/.bashrc