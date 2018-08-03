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
- 0.3.0.13
- 0.3.1.9
- 0.3.2.10
- 0.3.3.8

Note: As of writing, 0.3.3.9 has been released but the signing check fails.

Just set the TOR_VERSION variable as needed, but probably use the latest one!
