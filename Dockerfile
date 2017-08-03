FROM ubuntu:trusty
MAINTAINER haungh@objectcomputing.com

RUN apt-get update && \
    apt-get install -y software-properties-common python
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get -y install build-essential libxerces-c-dev g++-7 wget curl git unzip ninja-build bison flex qt4-dev-tools && \
    rm -rf /var/lib/apt/lists/*

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


RUN useradd -ms /bin/bash travis
USER travis
RUN mkdir -p /home/travis/usr
RUN cd /home/travis && \
    wget --no-check-certificate https://cmake.org/files/v3.9/cmake-3.9.0-Linux-x86_64.sh && \
    bash cmake-3.9.0-Linux-x86_64.sh --prefix=/home/travis/usr --exclude-subdir --skip-license && \
    rm cmake-3.9.0-Linux-x86_64.sh
ENV PATH /home/travis/usr/bin:$PATH

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ADD setup_opendds_workspace.sh /home/travis/usr/bin
ENTRYPOINT [ "/home/travis/usr/bin/setup_opendds_workspace.sh" ]