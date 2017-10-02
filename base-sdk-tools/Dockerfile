FROM ubuntu:14.04

MAINTAINER Matthew Herod "matthew.herod@gmail.com"

# Install java8
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Deps
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --force-yes expect git wget unzip libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Copy install tools
ENV PATH ${PATH}:/opt/tools

# Cleaning
RUN apt-get clean && rm -rf /tmp/*

# Install Android Tools
RUN cd /opt && mkdir -p /opt/android-sdk-linux

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux

RUN cd /opt && \
  wget --output-document=sdk-tools.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
  unzip -o sdk-tools.zip -d $ANDROID_HOME && \
  rm -f sdk-tools.zip && \
  chown -R root.root ${ANDROID_HOME} && \
  rm -f $ANDROID_HOME/tools/lib/common.jar

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg

ENV PATH ${PATH}:${ANDROID_HOME}/tools:$ANDROID_HOME/tools/bin:${ANDROID_HOME}/platform-tools

# Install SDK components
RUN cd /opt && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --update --channel=0 --include_obsolete && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'tools' && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'platform-tools'
  
ONBUILD RUN cd /opt && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --update --channel=0 --include_obsolete

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
