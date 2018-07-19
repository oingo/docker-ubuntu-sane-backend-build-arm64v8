FROM arm64v8/ubuntu:18.04

MAINTAINER Nox Wang "nox.gr.wang@gmail.com"

# Install (for SANE Backend).
RUN apt-get update >/dev/null && \
	apt-get install -y libusb-dev build-essential libsane-dev && \
	apt-get install -y libavahi-client-dev libavahi-glib-dev && \
	apt-get install -y git-core && \
	apt-get install -y autoconf libtool && \
	rm -rf /var/lib/apt/lists/*

# Compile SANE Backend.
RUN cd root && \
	git clone https://gitlab.com/sane-project/backends.git sane-backends && \
	cd sane-backends && \
	./configure --prefix=/usr --libdir=/usr/lib/aarch64-linux-gnu --sysconfdir=/etc --localstatedir=/var  --enable-avahi BACKENDS="kodakaio test" && \
	make

# Create a symbolic link for backend develop.
RUN cd /root/sane-backends/backend && \
	mkdir project && \
	ln -s /root/sane-backends/backend/project /root/project

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root
