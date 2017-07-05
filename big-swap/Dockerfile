FROM mherod/docker-android:latest

RUN cd /opt && \
	fallocate -l 2G /swapfile2G && \
	chown -R root.root /swapfile2G && \
	mkswap /swapfile2G && \
	swapon /swapfile2G && \
	swapoff /swapfile # < old swapfile && \
	rm /swapfile && \
	swapon -s # verify