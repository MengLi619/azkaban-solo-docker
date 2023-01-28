FROM ubuntu:20.04

# Install openjdk 8
RUN apt update && apt install -y openjdk-8-jdk

# Install Python 3.8
RUN apt install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install -y python3.8

# Install azkaban 3.81.0
ARG AZKABAN_VERSION=3.81.0
RUN apt install -y wget unzip git && \
    cd /tmp && \
    wget https://github.com/azkaban/azkaban/archive/${AZKABAN_VERSION}.zip && \
    unzip ${AZKABAN_VERSION}.zip && \
    mv azkaban-${AZKABAN_VERSION} azkaban

RUN cd /tmp/azkaban && \
    ./gradlew installDist && \
    cp -r /tmp/azkaban/azkaban-solo-server/build/install/azkaban-solo-server/ /azkaban && \
    cd /azkaban && \
    rm -rf /tmp/azkaban

WORKDIR /azkaban

COPY bootstrap.sh bin/
RUN chmod +x bin/bootstrap.sh

ENTRYPOINT ["bin/bootstrap.sh"]




