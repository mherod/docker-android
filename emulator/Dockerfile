FROM mherod/docker-android:base-sdk-tools
MAINTAINER Matthew Herod "matthew.herod@gmail.com"

ENV PATH ${PATH}:${ANDROID_HOME}/tools:$ANDROID_HOME/tools/bin:${ANDROID_HOME}/platform-tools
RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg && mkdir -p /root/.android/avd
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libqt5widgets5
ENV QT_QPA_PLATFORM offscreen
ENV ANDROID_EMULATOR_FORCE_32BIT true
ENV ANDROID_SDK_ROOT ${ANDROID_HOME}

RUN cd /opt && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager 'emulator' && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager 'system-images;android-26;google_apis;x86'
    
RUN mkdir $ANDROID_HOME/tools/keymaps && \
    touch $ANDROID_HOME/tools/keymaps/en-us

RUN ln -s ${ANDROID_HOME}/tools/lib64/qt ${ANDROID_HOME}/tools/lib

RUN apt-get clean && rm -rf /tmp/*

RUN mkdir -p /opt/workspace

WORKDIR /opt/workspace

ENV ANDROID_SDK_HOME /root/
ENV ANDROID_SDK_ROOT ${ANDROID_HOME}
ENV ANDROID_AVD_HOME /root/.android/avd/

RUN rm -rf /root/.android/avd/emulator-26-gapis.avd
RUN echo no | $ANDROID_HOME/tools/bin/avdmanager \
	 create avd --name emulator-26-gapis \
				--package 'system-images;android-26;google_apis;x86' \
				--abi 'google_apis/x86' \
				--force

RUN `which emulator` -list-avds
RUN `which emulator` -avd emulator-26-gapis -no-audio -no-window -gpu off -qemu -verbose -wipe-data

RUN until adb -e shell getprop init.svc.bootanim; do echo "waiting for boot"; sleep 1; done
RUN adb wait-for-device; adb devices; adb emu kill

ENTRYPOINT `which emulator` -avd emulator-26-gapis -no-audio -no-window -gpu off -verbose -qemu -usbdevice tablet -vnc :0 -wipe-data & && \
    until adb -e shell getprop init.svc.bootanim; do sleep 1; done && \
    adb devices
