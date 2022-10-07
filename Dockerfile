FROM amd64/ubuntu:18.04 AS base

EXPOSE 8788/tcp
EXPOSE 9766/tcp

ENV DEBIAN_FRONTEND=noninteractive

#Add ppa:bitcoin/bitcoin repository so we can install libdb4.8 libdb4.8++
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:bitcoin/bitcoin

#Install runtime dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools libminiupnpc10 \
	libevent-2.1 libevent-pthreads-2.1 \
	libdb4.8 libdb4.8++ \
	libboost-system1.65 libboost-filesystem1.65 libboost-chrono1.65 \
	libboost-program-options1.65 libboost-thread1.65 \
	libzmq5 && \
	apt-get clean

FROM base AS build

#Install build dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools build-essential libtool autotools-dev automake git \
	pkg-config libssl-dev libevent-dev bsdmainutils python3 \
	libboost-system1.65-dev libboost-filesystem1.65-dev libboost-chrono1.65-dev \
	libboost-program-options1.65-dev libboost-test1.65-dev libboost-thread1.65-dev \
	libzmq3-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev && \
	apt-get clean


#Build Virtualempire from source
COPY . /home/virtualempire/build/Virtualempire/
WORKDIR /home/virtualempire/build/Virtualempire
RUN ./autogen.sh && ./configure --disable-tests --with-gui=no && make

FROM base AS final

#Add our service account user
RUN useradd -ms /bin/bash virtualempire && \
	mkdir /var/lib/virtualempire && \
	chown virtualempire:virtualempire /var/lib/virtualempire && \
	ln -s /var/lib/virtualempire /home/virtualempire/.virtualempire && \
	chown -h virtualempire:virtualempire /home/virtualempire/.virtualempire

VOLUME /var/lib/virtualempire

#Copy the compiled binaries from the build
COPY --from=build /home/virtualempire/build/Virtualempire/src/virtualempired /usr/local/bin/virtualempired
COPY --from=build /home/virtualempire/build/Virtualempire/src/virtualempire-cli /usr/local/bin/virtualempire-cli

WORKDIR /home/virtualempire
USER virtualempire

CMD /usr/local/bin/virtualempired -datadir=/var/lib/virtualempire -printtoconsole -onlynet=ipv4
