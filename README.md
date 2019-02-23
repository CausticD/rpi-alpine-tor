# rpi-alpine-tor
Alpine Linux Tor for Raspberry Pi

This Dockerfile will create a SOCKS5 proxy, available on port 9050, designed for running on a Raspberry Pi 2/3. Key features:

- Based on Alpine Linux.
- Downloads the source files and keys directly from the Tor Project website.
- Verifies the signatures.
- Compiles the source.
- Easy to change variables in Dockerfile to update version etc.

Based on foertel/rpi-alpine-tor by Felix Oertel "https://github.com/foertel"

Currently works on Tor versions:
- 0.3.5.8
- 0.4.0.2-alpha

You must set the TOR_VERSION argument..

Use "--build-arg TOR_VERSION=0.3.5.8" or "--build-arg TOR_VERSION=0.4.0.2-alpha" etc. Set this to the version you want. For example:

> build.sh:
>   TOR_VERSION="0.3.4.11"
>   docker build -t causticd/rpi-alpine-tor:$TOR_VERSION --build-arg TOR_VERSION=$TOR_VERSION .
>

Available for use from https://hub.docker.com/r/causticd/rpi-alpine-tor
