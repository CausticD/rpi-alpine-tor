FROM armhf/alpine:latest
MAINTAINER Chris Davison

# Based on foertel/rpi-alpine-tor by Felix Oertel "https://github.com/foertel"

# - For the latest version, browse to: https://www.torproject.org/dist/
# - To read about the signing process, go here: https://www.torproject.org/docs/verifying-signatures.html.en
# - For the GPG Key itself, see here: https://www.torproject.org/docs/signing-keys.html.en
# - Alternate servers found here: https://github.com/nodejs/docker-node/issues/380

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
# and re-run the tor specific part of the process, starting here. 

# IMPORTANT: This is a required argument. You must use "--build-arg TOR_VERSION=0.3.5.8" or 
# "--build-arg TOR_VERSION=0.4.0.2-alpha" etc. Set this to the version you want. For example:
#
# build.sh
#   TOR_VERSION="0.3.4.11"
#   docker build -t causticd/rpi-alpine-tor:$TOR_VERSION --build-arg TOR_VERSION=$TOR_VERSION .
#

ARG TOR_VERSION

ENV TOR_GPG_KEY 0x6AFEE6D49E92B601
ENV PGP_KEY_SERVER pool.sks-keyservers.net

# Download the source files for Tor, and the signiture that goes with it. Verify the sig matches,
# and then compile. Lastly, quickly tidy up.

RUN cd /tmp \
	&& wget https://www.torproject.org/dist/tor-${TOR_VERSION}.tar.gz \
	&& wget https://www.torproject.org/dist/tor-${TOR_VERSION}.tar.gz.asc \
	&& gpg --keyserver ${PGP_KEY_SERVER} --recv-keys ${TOR_GPG_KEY} \
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
