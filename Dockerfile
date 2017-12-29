FROM armhf/alpine:latest
MAINTAINER Chris Davison

# Based on foertel/rpi-alpine-tor by Felix Oertel "https://github.com/foertel"

EXPOSE 9050

# Prepare the basic alpine based image. Add the various key packages.
RUN build_pkgs=" \
	openssl-dev \
	zlib-dev \
	libevent-dev \
	gnupg \
	" \
	&& runtime_pkgs=" \
	build-base \
	openssl \
	zlib \
	libevent \
	" \
	&& apk --update add ${build_pkgs} ${runtime_pkgs}

# Set important values here. These are split up so that if the process fails, you can change them
# and re-run the process, starting here. Browse https://www.torproject.org/dist/ for the latest files.
# Was: ENV TOR_VERSION 0.3.0.12
ENV TOR_VERSION 0.3.0.13
# NEW: ENV TOR_VERSION 0.3.1.9

#ENV TOR_GPG_KEY 0x4E2C6E8793298290
ENV TOR_GPG_KEY 0x6AFEE6D49E92B601

# Download the source files for Tor, and the signiture that goes with it. Verify the sig matches,
# and then compile. Lastly, quickly tidy up.

RUN cd /tmp \
	&& wget https://www.torproject.org/dist/tor-${TOR_VERSION}.tar.gz \
	&& wget https://www.torproject.org/dist/tor-${TOR_VERSION}.tar.gz.asc \
	&& gpg --keyserver pgp.mit.edu --recv-keys ${TOR_GPG_KEY} \
	&& gpg --fingerprint ${TOR_GPG_KEY} \
	&& gpg --verify tor-${TOR_VERSION}.tar.gz.asc tor-${TOR_VERSION}.tar.gz \
	&& tar xzf tor-${TOR_VERSION}.tar.gz \
	&& cd /tmp/tor-${TOR_VERSION} \
	&& ./configure \
	&& make -j6 \
	&& make install \
	&& cd \
	&& rm -rf /tmp/* \
	&& apk del ${build_pkgs} \
	&& rm -rf /var/cache/apk/*

RUN adduser -Ds /bin/sh tor

RUN mkdir /etc/tor
COPY torrc /etc/tor/

USER tor
CMD ["tor", "-f", "/etc/tor/torrc"]