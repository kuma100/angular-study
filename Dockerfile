FROM ubuntu:16.04

RUN set -x && \
    apt-get update && \
    apt-get install -y sudo vim less git openssh-server openssh-client curl iputils-ping traceroute && \
    apt-get install -y language-pack-ja-base language-pack-ja ibus-mozc && \
    update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" && \
    . /etc/default/locale && \
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    apt-get install -y nodejs build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo done.

RUN set -x && \
    npm install -g yarn && \
    yarn global add @angular/cli tslint typescript && \
    ng set --global packageManager=yarn && \
    echo done.

RUN set -x && \
    mkdir /app && \
    cd /app && \
    ng new sample-app && \
    echo done.

RUN set -x && \
    sudo wget -O /usr/local/bin/rsub https://raw.github.com/aurora/rmate/master/rmate && \
    ln -s /usr/local/bin/rsub /usr/local/bin/rmate && \
    chmod +x /usr/local/bin/rsub && \
    cd /app/sample-app && \
    yarn add @ng-bootstrap/ng-bootstrap amexio-ng-extensions && \
    echo done.

RUN set -x && \
    mkdir /var/run/sshd && \
    echo root:root | chpasswd && \
    ssh-keygen -A && \
    echo done.

WORKDIR /app

EXPOSE 22 4200

CMD ["/usr/sbin/sshd", "-o", "PermitRootLogin=yes", "-D"]
