FROM ubuntu:24.04

ARG FLUTTER_VERSION=3.35.7
ARG APP_VERSION=v2.0.0
# git tag or full commit SHA
ARG APP_VERSION_DISPLAY=2.0.0

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="${PATH}:/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/root/.pub-cache/bin"
ENV ANDROID_SDK_VERSION=11076708

RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip clang cmake ninja-build \
    libgtk-3-dev libayatana-appindicator3-dev libfuse2 \
    libmpv-dev mpv libmimalloc-dev libmimalloc2.0 openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git /opt/flutter \
&& cd /opt/flutter \
&& git checkout ${FLUTTER_VERSION}

RUN mkdir -p /opt/android-sdk/cmdline-tools \
    && cd /tmp \
    && curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip -o cmdline-tools.zip \
    && unzip cmdline-tools.zip \
    && mv cmdline-tools /opt/android-sdk/cmdline-tools/latest \
    && rm cmdline-tools.zip

RUN yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses

WORKDIR /

RUN git clone https://github.com/amphi2024/notes.git /amphi-notes \
&& cd /amphi-notes \
&& git checkout ${APP_VERSION} \
&& flutter precache --android \
&& flutter pub get \
&& flutter build apk \
&& flutter build apk --split-per-abi

#WORKDIR /amphi-notes
#
#RUN mv ./build/app/outputs/flutter-apk/app-release.apk ./build/Notes-${APP_VERSION_DISPLAY}-Android.apk \
#&& mv ./build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk ./build/Notes-${APP_VERSION_DISPLAY}-Android-armeabi_v7a.apk \
#&& mv ./build/app/outputs/flutter-apk/app-x86_64-release.apk ./build/Notes-${APP_VERSION_DISPLAY}-Android-x86_64.apk \
#&& mv ./build/app/outputs/flutter-apk/app-arm64-v8a-release.apk ./build/Notes-${APP_VERSION_DISPLAY}-Android-arm64_v8a.apk

# docker build -f build-apk.dockerfile -t amphi-notes-apk-builder .
# docker create --name build-output-apk amphi-notes-apk-builder
# docker cp build-output-apk:/build/. ./result