FROM ubuntu:24.04

ARG FLUTTER_VERSION=3.35.7
ARG APP_VERSION=COMMIT_SHA
# git tag or full commit SHA
ARG ARCH=arm64
# arm64 | x64
ARG APP_VERSION_DISPLAY=X.X.X
ARG ARCH_DISPLAY=arm64
# arm64 | x86_64
ARG APP_VERSION_PUBSPEC=X.X.X+X

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/flutter/bin:/root/.pub-cache/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip clang cmake ninja-build \
    libgtk-3-dev libayatana-appindicator3-dev libfuse2 \
    libmpv-dev mpv libmimalloc-dev libmimalloc2.0 \
    ca-certificates patchelf rpm build-essential fakeroot \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git /opt/flutter \
&& cd /opt/flutter \
&& git checkout ${FLUTTER_VERSION} \
&& flutter config --enable-linux-desktop \
&& dart pub global activate fastforge

WORKDIR /

RUN mkdir -p /tmp/build \
&& git clone https://github.com/amphi2024/notes.git /tmp/build/amphi-notes \
&& cd /tmp/build/amphi-notes \
&& git checkout ${APP_VERSION} \
&& flutter pub get \
&& fastforge package --platform linux --targets deb,rpm

WORKDIR /tmp/build/amphi-notes

RUN mv ./dist/${APP_VERSION_PUBSPEC}/notes-${APP_VERSION_PUBSPEC}-linux.deb ./dist/Notes-${APP_VERSION_DISPLAY}-Linux-${ARCH_DISPLAY}.deb \
&& mv ./dist/${APP_VERSION_PUBSPEC}/notes-${APP_VERSION_PUBSPEC}-linux.rpm ./dist/Notes-${APP_VERSION_DISPLAY}-Linux-${ARCH_DISPLAY}.rpm \
&& cd ./build/linux/${ARCH}/release/bundle \
&& tar -czvf ../../../../../dist/Notes-${APP_VERSION_DISPLAY}-Linux-${ARCH_DISPLAY}.tar.gz *

# docker build -f build-linux.dockerfile -t amphi-notes-linux-builder .
# docker create --name build-output amphi-notes-linux-builder
# docker cp build-output:/app/build/. ./result