FROM alpine:3.17.0 AS builder

RUN apk add --update --no-cache \
  build-base \
  git \
  poppler-qt5-dev \
  qt5-qtbase-dev \
  && git clone https://github.com/YACReader/yacreader.git \
  && git clone https://github.com/selmf/unarr.git \
  # build and install unarr
  && cd unarr \
  && mkdir build \
  && cd build \
  && cmake .. -DBUILD_SHARED_LIBS=ON -DENABLE_7Z=ON \
  && make \
  && make install \
  # build and install YACReaderLibraryServer
  && cd /yacreader/YACReaderLibraryServer \
  && qmake-qt5 "CONFIG+=unarr server_standalone" . \
  && make \
  && make install INSTALL_ROOT=/install

FROM alpine:3.17.0

RUN apk add --update --no-cache \
  qt5-qtbase \
  qt5-qtbase-sqlite \
  poppler-qt5

COPY --from=builder /install /
COPY --from=builder /usr/local /usr/local
COPY /entrypoint.sh /

VOLUME /config
VOLUME /comics

EXPOSE 8080/tcp

ENTRYPOINT /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=20s --start-period=20s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080 || exit 1
