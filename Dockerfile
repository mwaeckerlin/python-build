FROM mwaeckerlin/very-base

ENV CONTAINERNAME    "build/python"
USER root
RUN mkdir /app \
    && $ALLOW_BUILD /app \
    && $PKG_INSTALL git python3 py3-pip
USER $BUILD_USER
WORKDIR /app
