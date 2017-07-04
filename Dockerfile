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

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Install Android Tools
RUN cd /opt && mkdir -p /opt/android-sdk-linux

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux

RUN cd /opt && \
  wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
  tar xzf android-sdk.tgz -C $ANDROID_HOME/../ && \
  rm -f android-sdk.tgz && \
  wget --output-document=sdk-tools.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
  unzip -o sdk-tools.zip -d $ANDROID_HOME && \
  rm -f sdk-tools.zip && \
  chown -R root.root ${ANDROID_HOME} && \
  rm -f $ANDROID_HOME/tools/lib/common.jar

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg

ENV PATH ${PATH}:${ANDROID_HOME}/tools:$ANDROID_HOME/tools/bin:${ANDROID_HOME}/platform-tools

# Install SDK components
RUN cd /opt && \
  git clone https://github.com/mherod/android-sdk-licenses.git $ANDROID_HOME/licenses && \
  cd $ANDROID_HOME/ && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager --update --channel=3 --include_obsolete" && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager 'tools'" && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-25'" && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-26'" && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager 'ndk-bundle'" && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager 'extras;android;m2repository'" && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager 'extras;google;m2repository'" && \
  /opt/tools/android-accept-licenses.sh "$ANDROID_HOME/tools/bin/sdkmanager --list" && \

# Cleaning
RUN apt-get clean && \
  rm -rf /tmp/*

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
