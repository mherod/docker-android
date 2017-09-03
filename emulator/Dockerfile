FROM mherod/docker-android:base-sdk-tools
MAINTAINER Matthew Herod "matthew.herod@gmail.com"

ENV PATH ${PATH}:${ANDROID_HOME}/tools:$ANDROID_HOME/tools/bin:${ANDROID_HOME}/platform-tools
RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libqt5widgets5
ENV QT_QPA_PLATFORM offscreen
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${ANDROID_HOME}/tools/lib64
RUN apt-get clean && rm -rf /tmp/*
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
RUN adb devices

RUN cd /opt && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --update --channel=3 --include_obsolete && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager 'system-images;android-23;default;x86' && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --list

RUN echo no | $ANDROID_HOME/tools/bin/avdmanager \
	 create avd --name test23 \
				--package 'system-images;android-23;default;x86' \
				--abi 'default/x86' \
				--force

RUN cd $ANDROID_HOME/tools && \
    $ANDROID_HOME/tools/emulator -avd test23 &

RUN until adb -e shell getprop init.svc.bootanim; do sleep 1; done