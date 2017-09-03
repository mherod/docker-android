FROM mherod/docker-android:base-sdk-tools
MAINTAINER Matthew Herod "matthew.herod@gmail.com"

ENV PATH ${PATH}:${ANDROID_HOME}/tools:$ANDROID_HOME/tools/bin:${ANDROID_HOME}/platform-tools
RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libqt5widgets5
ENV QT_QPA_PLATFORM offscreen
ENV ANDROID_EMULATOR_FORCE_32BIT true
ENV ANDROID_AVD_HOME /root/.android/avd

RUN cd /opt && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager 'emulator' && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager 'system-images;android-23;default;x86'

RUN ln -s ${ANDROID_HOME}/tools/lib64/qt ${ANDROID_HOME}/tools/lib
RUN apt-get clean && rm -rf /tmp/*
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace

RUN echo no | $ANDROID_HOME/tools/bin/avdmanager \
	 create avd --name test23 \
				--package 'system-images;android-23;default;x86' \
				--abi 'default/x86' \
				--force

ENTRYPOINT sh -c 'cd $ANDROID_HOME/tools; $ANDROID_HOME/tools/emulator -avd test23 &' && \
    until adb -e shell getprop init.svc.bootanim; do sleep 1; done && \
    adb devices