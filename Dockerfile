FROM mherod/docker-android:base-sdk-tools

MAINTAINER Matthew Herod "matthew.herod@gmail.com"

# Copy install tools
COPY tools /opt/tools

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg

ENV PATH ${PATH}:${ANDROID_HOME}/tools:$ANDROID_HOME/tools/bin:${ANDROID_HOME}/platform-tools

# Cleaning
RUN apt-get clean && rm -rf /tmp/*

# GO to workspace
RUN mkdir -p /opt/workspace

# Install SDK components
RUN cd /opt && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --update --channel=3 --include_obsolete && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'tools' && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-25' && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-26' && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'ndk-bundle' && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'extras;android;m2repository' && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager 'extras;google;m2repository' && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --list
  
ONBUILD RUN cd /opt && \
  yes | $ANDROID_HOME/tools/bin/sdkmanager --update --channel=3 --include_obsolete && \

WORKDIR /opt/workspace
