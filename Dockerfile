FROM golang:1.20 as builder
WORKDIR /src
COPY go.mod main.go /src/
RUN CGO_ENABLED=0 go build -o bin/simple-http-server main.go && \
    chmod +x bin/simple-http-server

FROM ubuntu:23.10
LABEL org.opencontainers.image.authors="feiyudev"
LABEL author="feiyu.dev@gmail.com"

COPY --from=builder /src/bin/simple-http-server /root/simple-http-server

# apt source 参考链接： https://mirrors.ustc.edu.cn/help/ubuntu.html
# iproute2 安装 ip 命令
# dnsutils 安装 dig 命令
RUN sed -i 's|//.*archive.ubuntu.com|//mirrors.ustc.edu.cn|g' /etc/apt/sources.list && apt update
RUN apt install -y zsh curl git vim tree jq yq openssh-client nfs-common
RUN apt install -y bridge-utils dnsutils iproute2 netcat-openbsd tcpdump inetutils-ping inetutils-telnet inetutils-traceroute
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh  \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc \
    && sed -i '2s/# //g' /root/.zshrc \
    && sed -i 's/ZSH_THEME=.*/ZSH_THEME=ys/g' /root/.zshrc \
    && sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' /root/.zshrc

CMD ["/root/simple-http-server"]
