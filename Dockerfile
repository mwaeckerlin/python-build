FROM mwaeckerlin/build

# /app (owned by the build user), USER and WORKDIR are inherited from
# mwaeckerlin/build — recreating /app here aborted the build ("File exists")
ENV CONTAINERNAME="build/python"
ENV ADD_MODULES='for file in /usr/lib/python*  $(for f in $(find /usr/lib/python* -name '"'"'*.so*'"'"'); do ldd $f; done 2> /dev/null | sed -n '"'"'s,.* \([^ ]*/lib/[^ ]*\) .*,\1,p'"'"' | sort | uniq); do path=${file%/*}; test -d /tmp/root/$path || mkdir -p /tmp/root/$path; cp -La $file /tmp/root/$file; done'
