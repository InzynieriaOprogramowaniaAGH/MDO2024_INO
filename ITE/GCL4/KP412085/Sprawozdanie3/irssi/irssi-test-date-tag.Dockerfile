ARG IMAGE_TAG

FROM irssi-build:$IMAGE_TAG

WORKDIR /irssi/Build

RUN ninja test