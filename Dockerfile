FROM ubuntu
MAINTAINER Iurie Muradu "muradu.iurie.1986@gmail.com"

RUN apt update && apt install -y curl apt-utils expect openssl ssh gnupg2 vim net-tools iputils-ping openjdk-8-jdk

RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -b 2048 -q -N "" && \
    touch ~/.ssh/authorized_keys && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" | tee -a /root/.bashrc
RUN bin/bash -c "source /root/.bashrc"
RUN echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
RUN curl https://www.apache.org/dist/cassandra/KEYS | apt-key add -
RUN apt update

COPY deploy.sh /deploy.sh
COPY login.expect /login.expect
COPY config /root/.ssh/config

RUN DEBIAN_FRONTEND=noninteractive apt install -y cassandra
RUN cp /etc/cassandra/cassandra.yaml /etc/cassandra/cassandra.yaml.orig

EXPOSE 7199 8888 61620 61621

CMD /deploy.sh
