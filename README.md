## Simple Http Server

A simple http service based on Go, which containerized with lots of network commands. It may be helpful to test the network in kubernetes or container.

## Usage

To start a deployment of simple http server, just run:
```shell
kubectl apply -f \
  https://raw.githubusercontent.com/feiyudev/simple-http-server/master/shs-dep.yaml
```

If you can't reach out image registry or Internet, maybe you need to pull the image to your local machine, and then save it as a tar file, push it to your target, lastly import the tar file as an image, commands are as follows:
```shell
docker pull ghcr.io/feiyudev/shs:latest
docker save -o shs.tar ghcr.io/feiyudev/shs:latest
# transfer shs.tar to your target machine
ctr -n k8s.io image import shs.tar
```

## Commands Inside
- bridge-utils
- dnsutils
- iproute2
- netcat
- tcpdump
- inetutils-ping
- inetutils-telnet
- inetutils-traceroute
- zsh
- curl
- wget
- git
- vim
- tree
- jq
- yq

## Alternative
Simple Http Server's image was pushed to ghcr.io(Default in repo yaml) and docker.io, you can get it by 2 ways as follows:
- ghcr.io/feiyudev/shs:latest
- docker.io/feiyudev/shs:latest