FROM mwaeckerlin/very-base

ENV CONTAINERNAME    "build/python"
ENV ADD_MODULES      'for file in /usr/lib/python*  $(for f in $(find /usr/lib/python* -name '"'"'*.so*'"'"'); do ldd $f; done 2> /dev/null | sed -n '"'"'s,.* \([^ ]*/lib/[^ ]*\) .*,\1,p'"'"' | sort | uniq); do path=${file%/*}; test -d /tmp/root/$path || mkdir -p /tmp/root/$path; cp -La $file /tmp/root/$file; done'
USER root
RUN mkdir /app \
    && $ALLOW_BUILD /app \
    && $PKG_INSTALL git python3 py3-pip
USER $BUILD_USER
WORKDIR /app
